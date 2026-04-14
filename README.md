[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/d5nOy1eX)

q1:
    riscv64-linux-gnu-gcc -static q1.s q1.c -o q1
    qemu-riscv64 ./q1
q2:
     riscv64-linux-gnu-gcc -static q2.s -o q2
      qemu-riscv64 ./q2  85 96 70 80 102
q3:
    a: qemu-riscv64 ./target_akshara3101 < payload.txt
q4: gcc -shared -fPIC -o libfun.so fun.c 
    gcc -o q4 q4.c -ldl
    ./q4        

q5:
    riscv64-linux-gnu-gcc -static q5.s -o q5
    qemu-riscv64 ./q5