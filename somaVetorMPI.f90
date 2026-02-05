program somaVetorMPI
    use mpi
    implicit none

    integer :: ierr, rank, nprocs
    integer :: N, chunk, resto
    integer :: i, inicio_idx, fim_idx

    real(8) :: soma_local, soma_total
    real(8) :: t_inicio, t_fim, t_local
    real(8), allocatable :: tempos(:)

    N = 10000000

    call MPI_Init(ierr)
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, nprocs, ierr)

    if (nprocs /= 4) then
        if (rank == 0) print *, "Execute com exatamente 4 processos"
        call MPI_Finalize(ierr)
        stop
    end if

    chunk = N / nprocs
    resto = mod(N, nprocs)

    inicio_idx = rank * chunk + 1
    fim_idx    = inicio_idx + chunk - 1
    if (rank == nprocs-1) fim_idx = fim_idx + resto

    call MPI_Barrier(MPI_COMM_WORLD, ierr)

    t_inicio = MPI_Wtime()

    soma_local = 0.0d0
    do i = inicio_idx, fim_idx
        soma_local = soma_local + 1.0d0
    end do

    t_fim   = MPI_Wtime()
    t_local = t_fim - t_inicio

    call MPI_Reduce(soma_local, soma_total, 1, MPI_DOUBLE_PRECISION, &
                    MPI_SUM, 0, MPI_COMM_WORLD, ierr)

    if (rank == 0) allocate(tempos(nprocs))

    call MPI_Gather(t_local, 1, MPI_DOUBLE_PRECISION, &
                    tempos, 1, MPI_DOUBLE_PRECISION, &
                    0, MPI_COMM_WORLD, ierr)

    if (rank == 0) then
        print *
        print *, "====== TEMPO DE EXECUCAO ======"
        do i = 0, nprocs-1
            print '(A,I1,A,F10.6,A)', "Rank ", i, ": ", tempos(i+1), " s"
        end do
        print *, "Soma total =", soma_total
        print *, "==============================="
    end if

    call MPI_Finalize(ierr)

end program somaVetorMPI
