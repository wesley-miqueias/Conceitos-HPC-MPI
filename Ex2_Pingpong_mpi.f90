program mpi_troca_simples
    use mpi
    implicit none

    integer :: r, p, ierr
    integer :: source, dest, tag
    integer :: dado, ibuff
    integer :: status(MPI_STATUS_SIZE)

    tag  = 1
    dado = 0

    call MPI_Init(ierr)

    call MPI_Comm_rank(MPI_COMM_WORLD, r, ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, p, ierr)

    print *, 'Antes da com.: rank:', r, 'dado:', dado

    if (r == 0) then
        dest   = 1
        source = 1
        ibuff  = 10

        call MPI_Recv(dado, 1, MPI_INTEGER, source, tag, &
                      MPI_COMM_WORLD, status, ierr)

        call MPI_Send(ibuff, 1, MPI_INTEGER, dest, tag, &
                      MPI_COMM_WORLD, ierr)

    else
        dest   = 0
        source = 0
        ibuff  = 50

        call MPI_Send(ibuff, 1, MPI_INTEGER, dest, tag, &
                      MPI_COMM_WORLD, ierr)

        call MPI_Recv(dado, 1, MPI_INTEGER, source, tag, &
                      MPI_COMM_WORLD, status, ierr)
    end if

    print *, 'Depois da com.: rank:', r, 'dado:', dado

    call MPI_Finalize(ierr)

end program mpi_troca_simples
