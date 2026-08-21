package mx.edu.utez.locker.model;

public class CasilleroDto {
    private int idCasillero;
    private String codigo;
    private String edificio;
    private String piso;
    private String estado; // EJ: DISPONIBLE, OCUPADO, MANTENIMIENTO
    private String nombreAlumno;     // <-- Nuevo atributo
    private String matriculaAlumno;  // <-- Nuevo atributo

    public CasilleroDto() {}

    public CasilleroDto(int idCasillero, String codigo, String edificio, String piso, String estado) {
        this.idCasillero = idCasillero;
        this.codigo = codigo;
        this.edificio = edificio;
        this.piso = piso;
        this.estado = estado;
    }

    public int getIdCasillero() {
        return idCasillero;
    }

    public void setIdCasillero(int idCasillero) {
        this.idCasillero = idCasillero;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public String getEdificio() {
        return edificio;
    }

    public void setEdificio(String edificio) {
        this.edificio = edificio;
    }

    public String getPiso() {
        return piso;
    }

    public void setPiso(String piso) {
        this.piso = piso;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    // --- GETTERS Y SETTERS NUEVOS REQUERIDOS POR EL JSP ---
    public String getNombreAlumno() {
        return nombreAlumno;
    }

    public void setNombreAlumno(String nombreAlumno) {
        this.nombreAlumno = nombreAlumno;
    }

    public String getMatriculaAlumno() {
        return matriculaAlumno;
    }

    public void setMatriculaAlumno(String matriculaAlumno) {
        this.matriculaAlumno = matriculaAlumno;
    }
}