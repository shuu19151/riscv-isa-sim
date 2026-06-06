.section .text.init
.global _start

_start:
    # 1. Tắt tất cả các lõi CPU ngoại trừ lõi 0 (Core 0) để tránh xung đột ban đầu
    csrr a0, mhartid          # Đọc ID của phần cứng thread (Hart ID)
    bnez a0, park_core        # Nếu Hart ID != 0, nhảy đến vùng lặp vô hạn

    # 2. Thiết lập con trỏ ngăn xếp (Stack Pointer - sp)
    # _stack_top được định nghĩa bên file linker.ld
    la sp, _stack_top

    # 3. Xóa sạch vùng BSS (đưa các biến toàn cục chưa khởi tạo về số 0)
    la a0, _bss_start
    la a1, _bss_end
clear_bss:
    bgeu a0, a1, bss_done
    sd zero, 0(a0)            # Ghi 8-byte zero vào bộ nhớ
    addi a0, a0, 8
    j clear_bss

bss_done:
    # 4. Nhảy đến hàm main của C
    call main

_exit:
    # Nếu hàm main kết thúc, treo máy (hoặc xử lý shutdown)
park_core:
    wfi                       # Wait For Interrupt (tiết kiệm điện)
    j park_core               # Lặp vô hạn

.section .htif, "aw", @progbits
.align 6
.global tohost
tohost: .dword 0

.align 6
.global fromhost
fromhost: .dword 0
