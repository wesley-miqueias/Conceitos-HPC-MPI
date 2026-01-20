program hello_mpi
    use mpi
    implicit none

    integer :: ierr
    integer :: r, p

    ! Inicializa o MPI: início da região paralela
    call MPI_Init(ierr)

    ! Qual processo sou eu?
    call MPI_Comm_rank(MPI_COMM_WORLD, r, ierr)

    ! Quantos processos existem?
    call MPI_Comm_size(MPI_COMM_WORLD, p, ierr)

    print *, "Hello World from rank", r, "of", p, "processes."

    ! Finaliza o MPI
    call MPI_Finalize(ierr)
end program hello_mpi

! commit
