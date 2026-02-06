program somaVetor_mpi_mestre_escravo
    use mpi
    implicit none

    integer, parameter :: N = 1000000
    real(8), allocatable :: v(:)
    real(8) :: soma_local, soma_total
    integer :: rank, nprocs, ierr, chunk, i
    integer :: status(MPI_STATUS_SIZE)
    real(8) :: t0, t1

    call MPI_Init(ierr)
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, nprocs, ierr)

    if (rank == 0) then
        t0 = MPI_Wtime()

        chunk = N / nprocs
        soma_total = 0.0

        do i = 1, nprocs-1
            call MPI_Send(chunk, 1, MPI_INTEGER, i, 0, MPI_COMM_WORLD, ierr)
        end do

        allocate(v(chunk))
        v = real(rank + 1, 8)
        soma_total = sum(v)
        deallocate(v)

        do i = 1, nprocs-1
            call MPI_Recv(soma_local, 1, MPI_DOUBLE_PRECISION, i, 1, MPI_COMM_WORLD, status, ierr)
            soma_total = soma_total + soma_local
        end do

        t1 = MPI_Wtime()

        print *, "Processos =", nprocs
        print *, "Soma =", soma_total
        print *, "Tempo =", t1 - t0

    else
        call MPI_Recv(chunk, 1, MPI_INTEGER, 0, 0, MPI_COMM_WORLD, status, ierr)
        allocate(v(chunk))
        v = real(rank + 1, 8)
        soma_local = sum(v)
        call MPI_Send(soma_local, 1, MPI_DOUBLE_PRECISION, 0, 1, MPI_COMM_WORLD, ierr)
        deallocate(v)
    end if

    call MPI_Finalize(ierr)
end program somaVetor_mpi_mestre_escravo
