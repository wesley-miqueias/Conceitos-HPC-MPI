program somaVetor
   implicit none

   integer, parameter  :: N = 100000000, NT=
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
