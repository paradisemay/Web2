package ru.ifmo.se.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/controller")
public class ControllerServlet extends HttpServlet {
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

        if (xParam != null && yParam != null && radiusParam != null) {
            // Делегируем запрос на AreaCheckServlet
            request.getRequestDispatcher("/checkArea").forward(request, response);
        } else {
            // Перенаправляем на JSP страницу с формой
            request.getRequestDispatcher("/form.jsp").forward(request, response);
        }
    }
}
