package mx.edu.utez.locker.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mx.edu.utez.locker.dao.DaoAlumnoPortal;
import mx.edu.utez.locker.model.Alumno;
import mx.edu.utez.locker.model.AlumnoDashboardDto;
import mx.edu.utez.locker.model.SolicitudDto;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "InicioAlumnoServlet", value = "/alumno/inicio")
public class InicioAlumnoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Alumno alumno = (session != null) ? (Alumno) session.getAttribute("usuario") : null;

        if (alumno == null) {
            response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp?error=sin_permiso");
            return;
        }

        DaoAlumnoPortal daoPortal = new DaoAlumnoPortal();

        // 1. Obtener datos del Locker y Perfil
        AlumnoDashboardDto dashboard = daoPortal.obtenerDashboardAlumno(alumno.getIdAlumno());

        // 2. Obtener historial reciente de solicitudes
        List<SolicitudDto> historial = daoPortal.obtenerHistorialReciente(alumno.getIdAlumno());

        // 3. Enviar ambas variables a la vista JSP
        request.setAttribute("dashboard", dashboard);
        request.setAttribute("historial", historial);

        request.getRequestDispatcher("/views/alumno/inicio.jsp").forward(request, response);
    }
}