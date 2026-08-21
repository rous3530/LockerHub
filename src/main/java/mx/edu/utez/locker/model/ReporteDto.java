package mx.edu.utez.locker.model;

public class ReporteDto {
    private int idReporte;
    private int idSolicitud;
    private String descripcion;
    private String fechaCreacion;
    private String nombreEstudiante;

    public ReporteDto() {
    }

    public ReporteDto(int idReporte, int idSolicitud, String descripcion, String fechaCreacion, String nombreEstudiante) {
        this.idReporte = idReporte;
        this.idSolicitud = idSolicitud;
        this.descripcion = descripcion;
        this.fechaCreacion = fechaCreacion;
        this.nombreEstudiante = nombreEstudiante;
    }

    public int getIdReporte() {
        return idReporte;
    }

    public void setIdReporte(int idReporte) {
        this.idReporte = idReporte;
    }

    public int getIdSolicitud() {
        return idSolicitud;
    }

    public void setIdSolicitud(int idSolicitud) {
        this.idSolicitud = idSolicitud;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(String fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public String getNombreEstudiante() {
        return nombreEstudiante;
    }

    public void setNombreEstudiante(String nombreEstudiante) {
        this.nombreEstudiante = nombreEstudiante;
    }
}