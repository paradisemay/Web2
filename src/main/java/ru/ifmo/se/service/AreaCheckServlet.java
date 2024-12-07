package ru.ifmo.se.service;

import ru.ifmo.se.model.CheckResult;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/checkArea")
public class AreaCheckServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processCheck(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processCheck(request, response);
    }

    private void processCheck(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            double x = Double.parseDouble(request.getParameter("x"));
            double y = Double.parseDouble(request.getParameter("y"));
            double radius = Double.parseDouble(request.getParameter("radius"));

            boolean isInside;
            // Проверка на диапазон значений
            if (x < -5 || x > 3 || y < -3 || y > 5 || radius < 1 || radius > 4) {
                isInside = false;
            } else {
                isInside = isInsideSquare(x, y, radius) || isInsideCircle(x, y, radius) || isInsideTriangle(x, y, radius);
            }

            CheckResult result = new CheckResult(x, y, radius, isInside);

            HttpSession session = request.getSession();

            // Retrieve and safely cast results list
            List<CheckResult> results;
            Object sessionResults = session.getAttribute("results");
            if (sessionResults instanceof List<?>) {
                results = (List<CheckResult>) sessionResults;
            } else {
                results = new ArrayList<>();
            }
            results.add(result);
            session.setAttribute("results", results);

            session.setAttribute("currentX", x);
            session.setAttribute("currentY", y);
            session.setAttribute("currentR", radius);

            request.setAttribute("result", result);
            request.getRequestDispatcher("/result.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "Неверный формат чисел.");
            response.sendRedirect("controller");
        }
    }

    private boolean isInsideSquare(double x, double y, double radius) {
        return x <= 0 && y <= 0 && x >= -radius && y >= -radius;
    }

    private boolean isInsideCircle(double x, double y, double radius) {
        return x <= 0 && y >= 0 && (x * x + y * y) <= (radius / 2) * (radius / 2);
    }

    private boolean isInsideTriangle(double x, double y, double radius) {
        return x > 0 && y > 0 && y <= -x + radius / 2;
    }
}
