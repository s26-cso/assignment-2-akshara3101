.equ val, 0             #same like defining a variable in C
.equ node_left, 8       #Ex: #define node_left 8
.equ node_right, 16
.equ node_size, 24

.section .text
.global make_node
.global insert
.global get
.global getAtMost
.extern malloc

make_node:
    #Arguments: a0 = value
    #output: a0 = pointer to the new node
    
    addi sp, sp, -16
    sd ra, 8(sp)
    sd a0, 0(sp) 
    

    li a0, node_size
    call malloc

    ld t0, 0(sp)
    sw t0, val(a0)

    li t0, 0
    sd t0, node_left(a0)
    sd t0, node_right(a0)

    ld ra, 8(sp)
    addi sp, sp, 16
    ret

insert:
    # Arguments: a0 = root, a1 = val

    addi sp, sp, -24
    sd ra, 16(sp)
    sd a0, 0(sp)     # save root
    sd a1, 8(sp)     # save val

    beqz a0, make_new_node   # if root == NULL

    lw t0, val(a0)           # load root->val into t0
    blt a1, t0, insert_left      
    blt t0, a1, insert_right

    ld a0, 0(sp)
    j done                    

insert_left:
    ld t1, node_left(a0)     # load root->left
    mv a0, t1                # pass left as new root
    ld a1, 8(sp)
    call insert   
    ld t2, 0(sp)             #load original root
    sd a0, node_left(t2)     #root->left= returned node  
    
    mv a0, t2       
    j done

insert_right:
    ld t1, node_right(a0)    # load root->right
    mv a0, t1
    ld a1, 8(sp)
    call insert
    ld t2, 0(sp)             # load original root
    sd a0, node_right(t2)    # root->right= returned node
    
    mv a0, t2
    j done

make_new_node:
    ld a1, 8(sp)
    mv a0, a1                # move val into a0 for make_node
    call make_node           # returns new node in a0
    j done

done:
    ld ra, 16(sp)
    addi sp, sp, 24
    ret


get:
    # Arguments: a0 = root, a1 = val
    addi sp, sp, -16
    sd ra, 8(sp)
    sd a1, 0(sp)

    beqz a0, not_found

    lw t0, val(a0)

    beq a1, t0, found
    blt a1, t0, go_left
    blt t0, a1, go_right
    j get_done

go_right:
    ld a0, node_right(a0)
    ld a1, 0(sp)
    call get
    j get_done

go_left:
    ld a0, node_left(a0)
    ld a1, 0(sp)
    call get
    j get_done

found:
    j get_done        

not_found:
    li a0, 0
    j get_done

get_done:
    ld ra, 8(sp)
    addi sp, sp, 16
    ret


getAtMost:
    #Arguments: a0=value, a1=root

    li t0, -1          # ans=-1

loop:
    beqz a1, exit      # if root == NULL

    lw t1, val(a1)   # t1= root->val

    ble t1, a0, take    # if root->val <= val
    ld a1, node_left(a1) #if root->val>val search left
    j loop
take:
    mv t0, t1           # ans = root->val
    ld a1, node_right(a1)
    j loop

exit:
    mv a0, t0           # return ans
    ret
    