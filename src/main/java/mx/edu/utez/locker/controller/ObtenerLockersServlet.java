package mx.edu.utez.locker.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mx.edu.utez.locker.dao.DaoSolicitud;


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

        String idEdificioParam = request.getParameter("idEdificio");
        PrintWriter out = response.getWriter();

        if (idEdificioParam == null || idEdificioParam.isEmpty()) {
            out.print("[]");
            out.flush();
            return;
        }

        try {
            int idEdificio = Integer.parseInt(idEdificioParam);
            DaoSolicitud dao = new DaoSolicitud();
            List<DaoSolicitud.LockerDto> lockers = dao.obtenerLockersDisponiblesPorEdificio(idEdificio);

            // Construcción manual de JSON liviano
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < lockers.size(); i++) {
                DaoSolicitud.LockerDto l = lockers.get(i);
                json.append("{\"idLocker\":").append(l.getIdLocker())
                        .append(",\"numeroLocker\":\"").append(l.getNumeroLocker()).append("\"}");
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