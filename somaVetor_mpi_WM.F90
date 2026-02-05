program somaVetor_mpi
    use mpi                ! Habilita MPI
    implicit none

    integer, parameter :: N = 100000000, NT = 20
    real               :: v(N)
    real(8)            :: soma
    integer            :: i, j

    ! Variáveis do MPI
    integer :: rank, nprocs, ierr

    ! 1) Inicia o MPI
    call MPI_Init(ierr)

    ! 2) Quem sou eu? (meu número)
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)

    ! 3) Quantos processos existem?
    call MPI_Comm_size(MPI_COMM_WORLD, nprocs, ierr)

    ! ---- Código normal começa aqui ----

    do j = 1, NT

        do i = 1, N
            v(i) = 1.0
        end do

        soma = 0.0
        do i = 1, N
            soma = soma + v(i)
        end do

    end do

    ! Só o processo 0 imprime (evita bagunça)
    if (rank == 0) then
        print *, "Processos MPI =", nprocs
        print *, "NT            =", NT
        print *, "N             =", N
        print *, "Soma          =", soma
    end if

    ! 4) Finaliza o MPI
    call MPI_Finalize(ierr)

end program somaVetor_mpi
