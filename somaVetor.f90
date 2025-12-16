program somaVetor
<<<<<<< HEAD
   implicit none

   integer, parameter  :: N = 100000000, NT=1
   real                :: v(N)
   real(8)             :: soma
   integer             :: i,j

   
   do j=1, NT
     
      do i = 1, N
         v(i) = 1.0
      end do

   
      soma = 0.0
     
      do i = 1, N
         soma = soma + v(i)
      end do
   
   end do ! NT

   print*, "N     = ", N
   print*, "Soma  = ", soma

end program somaVetor
=======
    implicit none

    integer, parameter :: N = 100000000, NT=1
    real(8) :: v(N)
    real(8) :: soma
    integer :: i,j

    
    do i = 1, N
    v(i) = 1.0d0
    end do

    do j=1, NT
   
        soma = 0.0d0
        do i = 1, N
            soma = soma + v(i)
        end do
    end do    


    print *, "Soma =", soma

end program somaVetor
>>>>>>> 419202502b11ec7430cf63843a3871d70caa6e00
