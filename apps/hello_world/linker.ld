OUTPUT_ARCH( "riscv" )
ENTRY( _start )

MEMORY
{
  /* Định nghĩa vùng nhớ RAM bắt đầu từ 0x80000000 với độ lớn 128MB */
  RAM (wxa) : ORIGIN = 0x80000000, LENGTH = 128M
}

SECTIONS
{
  /* Đặt tất cả các section vào vùng nhớ RAM */
  . = ORIGIN(RAM);

  /* Section mã lệnh: ưu tiên code khởi động lên đầu tiên */
  .text : {
    *(.text.init)   /* Code từ entry.s */
    *(.text .text.*)
  } > RAM

  /* Section dữ liệu đã khởi tạo (ví dụ: int a = 5;) */
  .data : {
    . = ALIGN(4);
    *(.data .data.*)
    *(.rodata .rodata.*) /* Dữ liệu chỉ đọc như string bến C */
  } > RAM

  /* Section dữ liệu chưa khởi tạo (bắt buộc phải xóa về 0 trước khi vào main) */
  .bss : {
    . = ALIGN(8);
    _bss_start = .;
    *(.bss .bss.*)
    *(COMMON)
    . = ALIGN(8);
    _bss_end = .;
  } > RAM

  /* Định nghĩa vùng không gian cho Ngăn xếp (Stack) */
  .stack : {
    . = ALIGN(16);
    _stack_bottom = .;
    . += 0x4000;      /* Cấp phát 16KB không gian cho Stack */
    _stack_top = .;
  } > RAM

  _end = .;
}