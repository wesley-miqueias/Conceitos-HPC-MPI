rogram hello_mpi
    use mpi
    implicit none
    integer :: ierr

    call MPI_Init(ierr)

    print *, "Hello World"

    call MPI_Finalize(ierr)
end program hello_mpi

! commit
