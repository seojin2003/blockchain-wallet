// Chart.js 설정
(function() {
    // 이미 초기화된 경우 중복 실행 방지
    if (window.ChartManager) {
        console.warn('ChartManager가 이미 초기화되어 있습니다.');
        return;
    }

    const ChartManager = {
        chart: null,
        ctx: null,
        currentPeriod: '1D',
        updateTimer: null,
        isUpdating: false,
        UPDATE_INTERVAL: 10000,

        // 차트 설정
        config: {
            type: 'line',
            data: {
                labels: [],
                datasets: [{
                    label: 'ETH/KRW',
                    data: [],
                    borderColor: '#2563eb',
                    backgroundColor: 'rgba(37, 99, 235, 0.1)',
                    borderWidth: 1.5,
                    fill: true,
                    tension: 0.35,
                    pointRadius: 0,
                    pointHitRadius: 10,
                    spanGaps: true,
                    animation: {
                        duration: 800,
                        easing: 'easeOutQuad'
                    }
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                animation: {
                    duration: 800,
                    easing: 'easeOutQuad'
                },
                hover: {
                    mode: 'nearest',
                    intersect: false,
                    animationDuration: 100
                },
                interaction: {
                    intersect: false,
                    mode: 'index'
                },
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        enabled: true,
                        mode: 'index',
                        intersect: false,
                        animation: {
                            duration: 100
                        },
                        callbacks: {
                            label: function(context) {
                                return new Intl.NumberFormat('ko-KR', {
                                    style: 'currency',
                                    currency: 'KRW',
                                    maximumFractionDigits: 0
                                }).format(context.raw);
                            }
                        }
                    }
                },
                scales: {
                    x: {
                        grid: {
                            display: true,
                            color: 'rgba(0, 0, 0, 0.04)'
                        },
                        ticks: {
                            maxRotation: 0,
                            autoSkip: true,
                            maxTicksLimit: 8,
                            font: {
                                size: 11
                            }
                        }
                    },
                    y: {
                        position: 'left',
                        grid: {
                            color: 'rgba(0, 0, 0, 0.04)'
                        },
                        ticks: {
                            callback: function(value) {
                                return new Intl.NumberFormat('ko-KR', {
                                    style: 'currency',
                                    currency: 'KRW',
                                    maximumFractionDigits: 0
                                }).format(value);
                            },
                            font: {
                                size: 11
                            }
                        }
                    }
                }
            }
        },

        // 초기화
        init() {
            this.ctx = document.getElementById('priceChart');
            if (!this.ctx) {
                console.error('차트 캔버스를 찾을 수 없습니다.');
                return;
            }
            this.initializeChart();
            this.setupEventListeners();
            this.updateChartData(true);
            this.startUpdateTimer();
        },

        // 차트 초기화
        initializeChart() {
            if (this.chart) {
                this.chart.destroy();
                this.chart = null;
            }
            this.chart = new Chart(this.ctx, this.config);
        },

        // 이벤트 리스너 설정
        setupEventListeners() {
            document.querySelectorAll('.time-button').forEach(button => {
                button.addEventListener('click', async (e) => {
                    this.stopUpdateTimer();
                    document.querySelectorAll('.time-button').forEach(btn => {
                        btn.classList.remove('active');
                    });
                    e.target.classList.add('active');
                    this.currentPeriod = e.target.dataset.period;
                    await this.updateChartData(true);
                    this.startUpdateTimer();
                });
            });

            window.addEventListener('beforeunload', () => {
                this.cleanup();
            });
        },

        // 차트 데이터 업데이트
        async updateChartData(force = false) {
            if (this.isUpdating && !force) {
                console.log('이전 업데이트가 진행 중입니다.');
                return;
            }

            try {
                this.isUpdating = true;
                const params = new URLSearchParams({
                    period: this.currentPeriod,
                    t: new Date().getTime()
                });
                
                const response = await fetch(`/api/chart/price?${params.toString()}`, {
                    method: 'GET',
                    headers: {
                        'Accept': 'application/json',
                        'Cache-Control': 'no-cache',
                        'Pragma': 'no-cache'
                    },
                    credentials: 'same-origin'
                });

                if (!response.ok) {
                    if (response.status === 401) {
                        window.location.href = '/login';
                        return;
                    }
                    throw new Error(`HTTP error! status: ${response.status}`);
                }

                const data = await response.json();
                if (!data.labels?.length || !data.prices?.length) {
                    console.warn('데이터가 비어있습니다.');
                    return;
                }

                this.updateChartDisplay(data);
                this.updatePriceInfo(data);

            } catch (error) {
                console.error('차트 데이터 업데이트 중 오류 발생:', error);
            } finally {
                this.isUpdating = false;
            }
        },

        // 차트 디스플레이 업데이트
        updateChartDisplay(data) {
            if (!this.chart) {
                this.initializeChart();
            }

            // 데이터 포인트 수 줄이기
            const skipPoints = Math.ceil(data.labels.length / 50); // 최대 50개의 포인트만 표시
            
            // 데이터 필터링 (역순 정렬 제거)
            const filteredLabels = data.labels.filter((_, i) => i % skipPoints === 0);
            const filteredPrices = data.prices.filter((_, i) => i % skipPoints === 0);

            this.chart.data.labels = filteredLabels;
            this.chart.data.datasets[0].data = filteredPrices;

            const prices = filteredPrices.map(p => parseFloat(p));
            const minPrice = Math.min(...prices);
            const maxPrice = Math.max(...prices);
            const padding = (maxPrice - minPrice) * 0.1;

            this.chart.options.scales.y.min = Math.floor(minPrice - padding);
            this.chart.options.scales.y.max = Math.ceil(maxPrice + padding);

            this.chart.update();
        },

        // 가격 정보 업데이트
        updatePriceInfo(data) {
            const elements = {
                currentPrice: document.getElementById('currentPrice'),
                globalPrice: document.getElementById('globalPrice'),
                highPrice: document.getElementById('highPrice'),
                lowPrice: document.getElementById('lowPrice'),
                volume: document.getElementById('volume'),
                priceChange: document.getElementById('priceChange'),
                premium: document.getElementById('premium')
            };

            if (elements.currentPrice) elements.currentPrice.textContent = data.currentPrice;
            if (elements.globalPrice) elements.globalPrice.textContent = data.globalPrice;
            if (elements.highPrice) elements.highPrice.textContent = data.highPrice;
            if (elements.lowPrice) elements.lowPrice.textContent = data.lowPrice;
            if (elements.volume) elements.volume.textContent = data.volume;

            if (elements.priceChange) {
                const changeValue = parseFloat(data.priceChange);
                elements.priceChange.textContent = `${changeValue >= 0 ? '+' : ''}${changeValue.toFixed(2)}%`;
                this.setPriceChangeColor(elements.priceChange, changeValue);
            }

            if (elements.premium) {
                const premiumValue = parseFloat(data.premium);
                elements.premium.textContent = `${premiumValue >= 0 ? '+' : ''}${premiumValue.toFixed(2)}%`;
                this.setPriceChangeColor(elements.premium, premiumValue);
            }
        },

        // 가격 변화 색상 설정
        setPriceChangeColor(element, value) {
            element.className = 'price-change ' + (value > 0 ? 'price-up' : value < 0 ? 'price-down' : '');
        },

        // 타이머 시작
        startUpdateTimer() {
            this.stopUpdateTimer();
            this.updateTimer = setInterval(() => this.updateChartData(false), this.UPDATE_INTERVAL);
        },

        // 타이머 정지
        stopUpdateTimer() {
            if (this.updateTimer) {
                clearInterval(this.updateTimer);
                this.updateTimer = null;
            }
        },

        // 정리
        cleanup() {
            this.stopUpdateTimer();
            if (this.chart) {
                this.chart.destroy();
                this.chart = null;
            }
        }
    };

    // 전역 객체에 ChartManager 할당
    window.ChartManager = ChartManager;

    // DOM 로드 완료 시 초기화
    document.addEventListener('DOMContentLoaded', () => {
        ChartManager.init();
    });
})(); 