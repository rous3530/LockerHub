package mx.edu.utez.locker.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mx.edu.utez.locker.dao.DaoSolicitud;

import java.io.IOException;

@WebServlet(name = "SolicitudLockerServlet", value = "/solicitud-locker")
public class SolicitudLockerServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();

        // Obtener el ID del alumno firmado en sesión
        Integer idAlumno = (Integer) session.getAttribute("idAlumno");

        if (idAlumno == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Parámetros capturados en el formulario JSP
        String grupoActual = request.getParameter("grupo");
        String cuatriActual = request.getParameter("cuatrimestre");

        // Parsing con manejo básico por si los parámetros llegan nulos
        int idEdificio = 1;
        int idPeriodoCuatri = 1;

        try {
            if (request.getParameter("idEdificio") != null) {
                idEdificio = Integer.parseInt(request.getParameter("idEdificio"));
            }
            if (request.getParameter("idPeriodoCuatri") != null) {
                idPeriodoCuatri = Integer.parseInt(request.getParameter("idPeriodoCuatri"));
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        // Llamada al DAO con parámetros primitivos
        DaoSolicitud dao = new DaoSolicitud();
        boolean insertado = dao.registrarSolicitud(
                idAlumno,
                idEdificio,
                idPeriodoCuatri,
                grupoActual,
                cuatriActual
        );

        if (insertado) {
            response.sendRedirect(request.getContextPath() + "/alumno/dashboard.jsp?status=success");
        } else {
            response.sendRedirect(request.getContextPath() + "/alumno/solicitudLocker.jsp?status=error");
        }
    }
}