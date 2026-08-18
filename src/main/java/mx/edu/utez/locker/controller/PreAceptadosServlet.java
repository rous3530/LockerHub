package mx.edu.utez.locker.controller;

import mx.edu.utez.locker.dao.DaoSolicitud;
import mx.edu.utez.locker.model.Administrador;
import mx.edu.utez.locker.model.SolicitudDto;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/views/admin/pre-aceptacion")
public class PreAceptadosServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("========== [PreAceptadosServlet] INICIO DE PETICIÓN GET ==========");

        // 1. Control de acceso / Sesión
        HttpSession session = request.getSession(false);
        Administrador usuario = (session != null) ? (Administrador) session.getAttribute("usuario") : null;

        if (usuario == null || !"ADMIN".equalsIgnoreCase(usuario.getRol())) {
            System.out.println("[PreAceptadosServlet] ACCESO DENEGADO: Sesión inválida o rol no autorizado.");
            response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp");
            return;
        }

        System.out.println("[PreAceptadosServlet] Usuario autenticado: " + usuario.getCorreo());

        // 2. Consulta de datos mediante el DAO
        DaoSolicitud dao = new DaoSolicitud();

        System.out.println("[PreAceptadosServlet] Consultando lista de pre-aceptados en la BD...");
        List<SolicitudDto> listaPreAceptados = dao.obtenerSolicitudesPorEstado("PRE_ACEPTAD");

        System.out.println("[PreAceptadosServlet] Consultando métricas de casilleros y espera...");
        int casillerosDisponibles = dao.obtenerLockersDisponibles();
        int esperaCupo = dao.obtenerEsperaCupo();

        int totalEstudiantes = (listaPreAceptados != null) ? listaPreAceptados.size() : 0;

        // 3. Imprimir diagnóstico de resultados
        System.out.println("------------------ DIAGNÓSTICO DE DATOS ------------------");
        System.out.println("Total estudiantes pre-aceptados recuperados: " + totalEstudiantes);
        System.out.println("Casilleros disponibles: " + casillerosDisponibles);
        System.out.println("Estudiantes en espera de cupo: " + esperaCupo);

        if (listaPreAceptados != null && !listaPreAceptados.isEmpty()) {
            System.out.println("Detalle del primer registro:");
            SolicitudDto primerItem = listaPreAceptados.get(0);
            System.out.println("   - ID Solicitud: " + primerItem.getIdSolicitud());
            System.out.println("   - Matrícula: " + primerItem.getMatricula());
            System.out.println("   - Nombre: " + primerItem.getNombreCompleto());
            System.out.println("   - Locker: " + primerItem.getCasilleroCodigo());
        } else {
            System.out.println("ADVERTENCIA: 'listaPreAceptados' regresó vacía o NULL.");
        }
        System.out.println("----------------------------------------------------------");

        // 4. Inyección de variables al RequestScope
        request.setAttribute("listaPreAceptados", listaPreAceptados);
        request.setAttribute("totalEstudiantes", totalEstudiantes);
        request.setAttribute("casillerosDisponibles", casillerosDisponibles);
        request.setAttribute("esperaCupo", esperaCupo);

        System.out.println("[PreAceptadosServlet] Redirigiendo a /views/admin/pre-aceptacion.jsp");
        System.out.println("========== [PreAceptadosServlet] FIN DE PETICIÓN GET ==========");

        request.getRequestDispatcher("/views/admin/pre-aceptacion.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("[PreAceptadosServlet] Petición POST recibida, reenviando a doGet()");
        doGet(request, response);
    }
}