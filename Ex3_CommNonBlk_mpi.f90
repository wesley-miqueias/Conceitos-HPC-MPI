program anel_nao_bloqueante_mpi
    use mpi
    implicit none

    integer :: rank, p, ierr
    integer :: esq, dir
    integer :: buf(2)
    integer :: tag1, tag2

    integer :: reqs(4)
    integer :: stats(MPI_STATUS_SIZE, 4)

    tag1 = 1
    tag2 = 2

    call MPI_Init(ierr)
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, p, ierr)

    ! Definindo vizinhos (topologia circular)
    esq = rank - 1
    dir = rank + 1

    if (rank == 0)     esq = p - 1
    if (rank == p - 1) dir = 0

    ! Recebimentos não-bloqueantes
    call MPI_Irecv(buf(1), 1, MPI_INTEGER, esq, tag1, &
                   MPI_COMM_WORLD, reqs(1), ierr)

    call MPI_Irecv(buf(2), 1, MPI_INTEGER, dir, tag2, &
                   MPI_COMM_WORLD, reqs(2), ierr)

    ! Envios não-bloqueantes
    call MPI_Isend(rank, 1, MPI_INTEGER, esq, tag2, &
                   MPI_COMM_WORLD, reqs(3), ierr)

    call MPI_Isend(rank, 1, MPI_INTEGER, dir, tag1, &
                   MPI_COMM_WORLD, reqs(4), ierr)

    ! Espera todas as comunicações
    call MPI_Waitall(4, reqs, stats, ierr)

    print *, 'Rank', rank, ':: viz esq:', buf(1), 'viz dir:', buf(2)

    call MPI_Finalize(ierr)

end program anel_nao_bloqueante_mpi
