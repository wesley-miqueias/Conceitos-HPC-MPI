program somaVetor_mpi_mestre_escravo
    use mpi
    implicit none

    integer, parameter :: N = 1000000
    real(8), allocatable :: v(:)
    real(8) :: soma_local, soma_total
    real(8) :: t0, t1, tempo_local, tempo_max
    integer :: rank, nprocs, ierr, chunk, i
    integer :: status(MPI_STATUS_SIZE)

    call MPI_Init(ierr)
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, nprocs, ierr)

    chunk = N / nprocs

    call MPI_Barrier(MPI_COMM_WORLD, ierr)
    t0 = MPI_Wtime()

    if (rank == 0) then

        soma_total = 0.0

        ! Envia o tamanho do trabalho
        do i = 1, nprocs-1
            call MPI_Send(chunk, 1, MPI_INTEGER, i, 0, MPI_COMM_WORLD, ierr)
        end do

        allocate(v(chunk))
        v = 1.0_8
        soma_local = sum(v)
        soma_total = soma_local
        deallocate(v)

        ! Recebe as somas
        do i = 1, nprocs-1
            call MPI_Recv(soma_local, 1, MPI_DOUBLE_PRECISION, i, 1, MPI_COMM_WORLD, status, ierr)
            soma_total = soma_total + soma_local
        end do

        t1 = MPI_Wtime()

    else

        call MPI_Recv(chunk, 1, MPI_INTEGER, 0, 0, MPI_COMM_WORLD, status, ierr)

        allocate(v(chunk))
        v = 1.0_8
        soma_local = sum(v)
        deallocate(v)

        call MPI_Send(soma_local, 1, MPI_DOUBLE_PRECISION, 0, 1, MPI_COMM_WORLD, ierr)

    end if

    tempo_local = MPI_Wtime() - t0

    ! pega o MAIOR tempo (o que define o desempenho real)
    call MPI_Reduce(tempo_local, tempo_max, 1, MPI_DOUBLE_PRECISION, MPI_MAX, 0, MPI_COMM_WORLD, ierr)

    call MPI_Barrier(MPI_COMM_WORLD, ierr)

    ! imprime em ordem
    do i = 0, nprocs-1
        if (rank == i) then
            write(*,'(A,I2,A,F10.6,A)') "Rank ", rank, " -> Tempo = ", tempo_local, " s"
        end if
        call MPI_Barrier(MPI_COMM_WORLD, ierr)
    end do

    if (rank == 0) then
        print *
        print *, "============================"
        write(*,'(A,I2)') "Processos = ", nprocs
        write(*,'(A,F12.0)') "Soma correta = ", soma_total
        write(*,'(A,F10.6,A)') "Tempo TOTAL (max) = ", tempo_max, " s"
        print *, "============================"
    end if

    call MPI_Finalize(ierr)

end program somaVetor_mpi_mestre_escravo
