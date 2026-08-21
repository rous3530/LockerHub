package mx.edu.utez.locker.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mx.edu.utez.locker.dao.DaoSolicitud;
import mx.edu.utez.locker.model.Administrador;
import mx.edu.utez.locker.model.CasilleroDto;
import mx.edu.utez.locker.model.EdificioDto;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "GestionLockerServlet", value = "/admin/gestionLocker")
public class GestionLockerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Validación de sesión y rol de Administrador
        HttpSession sesion = request.getSession(false);
        Administrador admin = (sesion != null) ? (Administrador) sesion.getAttribute("usuario") : null;

        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRol())) {
            response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp?error=sin_permiso");
            return;
        }

        try {
            DaoSolicitud dao = new DaoSolicitud();

            // 2. Cargar los datos necesarios desde los DAOs
            List<EdificioDto> listaEdificios = dao.obtenerEdificios();
            List<CasilleroDto> listaCasilleros = dao.obtenerTodosLosCasilleros();

// 3. Calcular las métricas dinámicamente en base a la lista obtenida
            int totalCasilleros = 0;
            int ocupados = 0;
            int disponibles = 0;
            int mantenimiento = 0;

            if (listaCasilleros != null) {
                totalCasilleros = listaCasilleros.size();
                for (CasilleroDto c : listaCasilleros) {
                    if (c.getEstado() != null) {
                        String estado = c.getEstado().toUpperCase();
                        if (estado.contains("OCUPADO")) {
                            ocupados++;
                        } else if (estado.contains("DISPONIBLE")) {
                            disponibles++;
                        } else if (estado.contains("MANTENIMIENTO")) {
                            mantenimiento++;
                        }
                    }
                }
            }

            // Calcular porcentaje libre con formato (ej. formato entero o con 2 decimales)
            String porcentajeLibre = "0";
            if (totalCasilleros > 0) {
                double calc = ((double) disponibles * 100) / totalCasilleros;
                porcentajeLibre = String.format("%.0f", calc); // Cambia a "%.2f" si quieres 2 decimales, o "%.0f" para enteros limpios
            }

            // 4. Enviar todos los atributos al request
            request.setAttribute("listaEdificios", listaEdificios);
            request.setAttribute("listaCasilleros", listaCasilleros);
            request.setAttribute("totalCasilleros", totalCasilleros);
            request.setAttribute("ocupados", ocupados);
            request.setAttribute("disponibles", disponibles);
            request.setAttribute("mantenimiento", mantenimiento);
            request.setAttribute("porcentajeLibre", porcentajeLibre);

        } catch (Exception e) {
            e.printStackTrace();
        }

        // 5. Redirigir hacia la vista JSP ubicada en tu carpeta protegida/views
        request.getRequestDispatcher("/views/admin/gestionLocker.jsp").forward(request, response);
    }
}