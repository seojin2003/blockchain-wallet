package com.wallet.config;

import com.wallet.service.CustomUserDetailsService;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.csrf.CookieCsrfTokenRepository;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final CustomUserDetailsService userDetailsService;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationSuccessHandler successHandler() {
        SimpleUrlAuthenticationSuccessHandler handler = new SimpleUrlAuthenticationSuccessHandler();
        handler.setDefaultTargetUrl("/wallet");
        handler.setAlwaysUseDefaultTargetUrl(true);
        return handler;
    }

    @Bean
    public AuthenticationFailureHandler failureHandler() {
        return new AuthenticationFailureHandler() {
            @Override
            public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
                                              AuthenticationException exception) throws IOException, ServletException {
                String errorMessage;
                
                if (exception.getCause() instanceof UsernameNotFoundException || 
                    exception instanceof UsernameNotFoundException) {
                    errorMessage = "존재하지 않는 회원입니다.";
                } else if (exception instanceof BadCredentialsException) {
                    errorMessage = "비밀번호가 올바르지 않습니다.";
                } else {
                    errorMessage = "로그인에 실패했습니다.";
                }
                
                request.getSession().setAttribute("loginError", errorMessage);
                response.sendRedirect("/login?error=true");
            }
        };
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authConfig) throws Exception {
        return authConfig.getAuthenticationManager();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .headers()
                .frameOptions().sameOrigin()
                .addHeaderWriter((request, response) -> {
                    response.setHeader("Permissions-Policy", "fullscreen=*");
                })
                .and()
            .csrf()
                .csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse())
                .and()
            .authorizeRequests()
                .antMatchers("/css/**", "/js/**", "/images/**", "/static/**", "/webjars/**", "/**/*.pdf").permitAll()
                .antMatchers("/", "/login", "/register", "/signup", "/api/register", "/api/check-username").permitAll()
                .antMatchers("/api/**").authenticated()
                .anyRequest().authenticated()
                .and()
            .formLogin()
                .loginPage("/login")
                .loginProcessingUrl("/login")
                .defaultSuccessUrl("/wallet")
                .failureUrl("/login?error=true")
                .permitAll()
                .and()
            .logout()
                .logoutUrl("/logout")
                .logoutSuccessUrl("/login")
                .invalidateHttpSession(true)
                .deleteCookies("JSESSIONID")
                .permitAll();

        return http.build();
    }
} 