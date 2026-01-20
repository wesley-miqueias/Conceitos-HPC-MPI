program somaVetor_MPI_NT
   use mpi
   implicit none

   integer, parameter :: N = 100000000
   integer, parameter :: NT_total = 50

   real               :: v(N)
   real(8)            :: soma_local, soma_total
   integer            :: i, j

   integer            :: rank, p, ierr
   integer            :: inicio, fim, bloco

   call MPI_Init(ierr)
   call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
   call MPI_Comm_size(MPI_COMM_WORLD, p, ierr)

  
   ! Divisão do trabalho (NT)
   
   bloco  = NT_total / p
   inicio = rank * bloco + 1
   fim    = inicio + bloco - 1

   if (rank == p-1) then
      fim = NT_total
   end if

   print *, 'Rank', rank, 'executa j =', inicio, 'ate', fim

   soma_local = 0.0

   do j = inicio, fim

      do i = 1, N
         v(i) = 1.0
      end do

      do i = 1, N
         soma_local = soma_local + v(i)
      end do

   end do

   print *, 'Rank', rank, 'soma local =', soma_local


   ! Envio das somas para o rank 0
 
   call MPI_Reduce(soma_local, soma_total, 1, MPI_DOUBLE_PRECISION, &
                   MPI_SUM, 0, MPI_COMM_WORLD, ierr)

   if (rank == 0) then
      print *, '--------------------------------'
      print *, 'NT total =', NT_total
      print *, 'Processos =', p
      print *, 'SOMA TOTAL =', soma_total
   end if

   call MPI_Finalize(ierr)

end program somaVetor_MPI_NT
