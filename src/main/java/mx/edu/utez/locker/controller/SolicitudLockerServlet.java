package mx.edu.utez.locker.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mx.edu.utez.locker.dao.DaoSolicitud;
import mx.edu.utez.locker.model.Alumno; // Asegúrate de importar tu modelo Alumno

import java.io.IOException;

@WebServlet(name = "SolicitudLockerServlet", value = "/solicitud-locker")
public class SolicitudLockerServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        // 1. Validar si la sesión existe y si el atributo "usuario" está presente
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp?error=sin_sesion");
            return;
        }

        // 2. Extraer el ID del alumno desde el objeto Alumno guardado en la sesión
        Object objUsuario = session.getAttribute("usuario");
        Integer idAlumno = null;

        if (objUsuario instanceof Alumno) {
            Alumno alumno = (Alumno) objUsuario;
            idAlumno = alumno.getIdAlumno(); // Asegúrate de que el getter en tu clase Alumno se llame así (ej. getIdAlumno() o getId())
        }

        // Si por alguna razón no es un alumno válido o no tiene ID, rechazar
        if (idAlumno == null) {
            response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp?error=sin_permiso");
            return;
        }

        // 3. Parámetros capturados en el formulario JSP
        String grupoActual = request.getParameter("grupo");
        String cuatriActual = request.getParameter("cuatrimestre");
        String idEdificio = request.getParameter("idEdificio");
        String idLocker = request.getParameter("idLocker");

        String idPeriodoCuatriStr = request.getParameter("idPeriodoCuatri");
        int idPeriodoCuatri = (idPeriodoCuatriStr != null && !idPeriodoCuatriStr.isEmpty()) ? Integer.parseInt(idPeriodoCuatriStr) : 1;

        try {
            DaoSolicitud dao = new DaoSolicitud();
            boolean insertado = dao.registrarSolicitud(
                    idAlumno,
                    idEdificio,
                    idLocker,
                    idPeriodoCuatri,
                    grupoActual,
                    cuatriActual
            );

            if (insertado) {
                response.sendRedirect(request.getContextPath() + "/views/alumno/solicitudLocker.jsp?status=success");
            } else {
                response.sendRedirect(request.getContextPath() + "/views/alumno/solicitudLocker.jsp?status=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/alumno/solicitudLocker.jsp?status=error");
        }
    }
}