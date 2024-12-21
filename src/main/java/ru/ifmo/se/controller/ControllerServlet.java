package ru.ifmo.se.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/controller")
public class ControllerServlet extends HttpServlet {
    private static final int MAX_DECIMALS = 2;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String xParam = request.getParameter("x");
        String yParam = request.getParameter("y");
        String radiusParam = request.getParameter("radius");

        if (isValid(xParam, yParam, radiusParam)) {
            // Делегируем запрос на AreaCheckServlet
            request.getRequestDispatcher("/checkArea").forward(request, response);
        } else {
            // Перенаправляем на страницу с ошибкой
            request.getRequestDispatcher("/form.jsp").forward(request, response);
        }
    }

    private boolean isValid(String xParam, String yParam, String radiusParam) {
        if (xParam == null || yParam == null || radiusParam == null) {
            return false;
        }
        try {
            // Проверяем количество цифр после запятой
            if (hasTooManyDecimals(xParam) || hasTooManyDecimals(yParam) || hasTooManyDecimals(radiusParam)) {
                return false;
            }

            Double.parseDouble(xParam);
            Double.parseDouble(yParam);
            Double.parseDouble(radiusParam);

            // Проверяем диапазоны
            return true;
        } catch (NumberFormatException e) {
            // Если параметры не могут быть преобразованы в числа
            return false;
        }
    }

    private boolean hasTooManyDecimals(String value) {
        if (value == null) {
            return false;
        }
        int indexOfDot = value.indexOf('.');
        if (indexOfDot == -1) {
            return false; // Нет дробной части
        }
        return value.length() - indexOfDot - 1 > MAX_DECIMALS;
    }
}
