package mx.edu.utez.locker.controller;

import mx.edu.utez.locker.model.Alumno;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ActualizarPerfilServlet", urlPatterns = {"/alumno/actualizarPerfil"})
public class ActualizarPerfilServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Validar la sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp?error=sin_permiso");
            return;
        }

        Alumno alumnoSesion = (Alumno) session.getAttribute("usuario");

        // 2. Obtener los datos enviados desde el formulario JSP
        String nombre = request.getParameter("nombre");
        String matricula = request.getParameter("matricula");
        String carrera = request.getParameter("carrera1");
        String passwordActual = request.getParameter("passwordActual");
        String passwordNueva = request.getParameter("passwordNueva");

        // 3. Lógica de validación y actualización en Base de Datos
        // NOTA: Aquí debes instanciar tu clase DAO para interactuar con la BD.
        // AlumnoDao dao = new AlumnoDao();

        boolean actualizacionExitosa = false;

        try {
            // Ejemplo de lógica:
            // if (dao.validarPassword(alumnoSesion.getId(), passwordActual)) {
            //     alumnoSesion.setNombres(nombre);
            //     alumnoSesion.setMatricula(matricula);
            //     if (passwordNueva != null && !passwordNueva.isEmpty()) {
            //         alumnoSesion.setPassword(passwordNueva); // Recuerda encriptarla
            //     }
            //     actualizacionExitosa = dao.actualizarPerfil(alumnoSesion);
            // }

            actualizacionExitosa = true; // Simulación para que no marque error ahora mismo

            if (actualizacionExitosa) {
                // Actualizamos el objeto en la sesión para que la vista refleje los cambios
                session.setAttribute("usuario", alumnoSesion);
                response.sendRedirect(request.getContextPath() + "/views/alumno/editarPerfil.jsp?mensaje=exito");
            } else {
                response.sendRedirect(request.getContextPath() + "/views/alumno/editarPerfil.jsp?error=datos_invalidos");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/alumno/editarPerfil.jsp?error=excepcion");
        }
    }
}