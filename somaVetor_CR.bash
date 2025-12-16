#!/bin/bash

SOURCE="somaVetor_CR"
#OPTS=("-O0" "-O1" "-O2" "-O3")
OPTS=("-O0")




echo "--- Compilação e Teste (O0 a O3) ---"

for OPT in "${OPTS[@]}"
do

   nti=1
   ntf=100
   nt=${nti}
   
   while [ ${nt} -le ${ntf} ]
   do

cat >${SOURCE}.f90 <<EOF
program somaVetor
   implicit none

   integer, parameter  :: N = 100000000, NT=${nt}
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

   print*, "NT    = ", NT
   print*, "N     = ", N
   print*, "Soma  = ", soma

end program somaVetor
EOF


      OUTPUT="${SOURCE}_${OPT//-}.x"
      echo -n "Compilando $OPT... "
      
      gfortran $OPT ${SOURCE}.f90 -o $OUTPUT 
      
      echo " OK" 
      
      if [ -s "$OUTPUT" ] 
      then
         echo "--- Tempo para $OPT ---"
         time ./"$OUTPUT"
         echo "----------------------"
      fi
      
      nt=$((nt+1))
   done
   
   echo ""
   echo "======================"
   echo ""
   sleep 3
      
done
