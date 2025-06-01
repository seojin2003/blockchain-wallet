<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>오류 발생 - 블록체인 월렛</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100">
    <div class="min-h-screen flex items-center justify-center">
        <div class="max-w-md w-full bg-white shadow-lg rounded-lg p-8">
            <div class="text-center">
                <h2 class="text-2xl font-bold text-red-600 mb-4">오류가 발생했습니다</h2>
                <p class="text-gray-600 mb-4">
                    죄송합니다. 요청을 처리하는 동안 오류가 발생했습니다.
                </p>
                <div class="bg-red-50 border border-red-200 rounded-md p-4 mb-4">
                    <p class="text-sm text-red-700">
                        오류 코드: ${status}<br>
                        <c:if test="${not empty message}">
                            메시지: ${message}<br>
                        </c:if>
                        <c:if test="${not empty exception}">
                            예외: ${exception}
                        </c:if>
                    </p>
                </div>
                <div class="flex justify-center space-x-4">
                    <a href="/" class="inline-flex items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700">
                        홈으로 돌아가기
                    </a>
                    <button onclick="history.back()" class="inline-flex items-center px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50">
                        이전 페이지로
                    </button>
                </div>
            </div>
        </div>
    </div>
</body>
</html> 