package mx.edu.utez.locker.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mx.edu.utez.locker.dao.DaoSolicitud;
import mx.edu.utez.locker.model.Administrador;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "ObtenerLockersServlet", value = "/obtener-lockers")
public class ObtenerLockersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();

        // 1. VALIDACIÓN DE SEGURIDAD EXCLUSIVA PARA ADMINISTRADOR
        HttpSession sesion = request.getSession(false);
        Administrador admin = (sesion != null) ? (Administrador) sesion.getAttribute("usuario") : null;

        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRol())) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("[]");
            out.flush();
            return;
        }

        // 2. RECUPERAR PARÁMETRO DE EDIFICIO
        String idEdificioParam = request.getParameter("idEdificio");
        if (idEdificioParam == null || idEdificioParam.isEmpty()) {
            out.print("[]");
            out.flush();
            return;
        }

        try {
            int idEdificio = Integer.parseInt(idEdificioParam);
            DaoSolicitud dao = new DaoSolicitud();
            List<DaoSolicitud.LockerDto> lockers = dao.obtenerLockersPorEdificio(idEdificio);

            // 3. CONSTRUCCIÓN DE JSON (Incluyendo el piso opcionalmente si tu DTO lo tiene)
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < lockers.size(); i++) {
                DaoSolicitud.LockerDto l = lockers.get(i);
                json.append("{\"idLocker\":").append(l.getIdLocker())
                        .append(",\"numeroLocker\":\"").append(l.getNumeroLocker()).append("\"")
                        .append(",\"piso\":\"").append(l.getPiso() != null ? l.getPiso() : "").append("\"}");
                if (i < lockers.size() - 1) {
                    json.append(",");
                }
            }
            json.append("]");

            out.print(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            out.print("[]");
        }
        out.flush();
    }
}