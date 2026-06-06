# 1. Khai báo các cấu hình trình biên dịch chéo
CROSS_COMPILE = riscv64-unknown-elf-
CC            = $(CROSS_COMPILE)gcc
OBJCOPY       = $(CROSS_COMPILE)objcopy
OBJDUMP       = $(CROSS_COMPILE)objdump

# 2. Các cờ biên dịch quan trọng (bắt buộc phải có -mcmodel=medany)
CFLAGS        = -Wall -O2 -mcmodel=medany -ffreestanding
LDFLAGS       = -nostdlib -T linker.ld -mcmodel=medany

# 3. Tên file thực thi đầu ra
TARGET        = hello

# 4. Danh sách các file đối tượng (Object files) cần tạo
OBJS          = entry.o hello.o

# --- Các quy tắc biên dịch (Rules) ---

# Quy tắc mặc định khi gõ lệnh 'make'
all: $(TARGET)

# Quy tắc liên kết (Link) các file .o thành file thực thi ELF
$(TARGET): $(OBJS) linker.ld
	$(CC) $(LDFLAGS) -o $(TARGET) $(OBJS)
	@echo "============================================="
	@echo " 🎉 Biên dịch THÀNH CÔNG file bare-metal: $(TARGET)"
	@echo " 🚀 Chạy lệnh sau để test: spike ./$(TARGET)"
	@echo "============================================="

# Quy tắc dịch file assembly (entry.s -> entry.o)
entry.o: entry.s
	$(CC) $(CFLAGS) -c entry.s -o entry.o

# Quy tắc dịch file C (hello.c -> hello.o)
hello.o: hello.c
	$(CC) $(CFLAGS) -c hello.c -o hello.o

# Quy tắc dọn dẹp các file tạm sau khi build xong
clean:
	rm -f $(OBJS) $(TARGET)
	@echo " 🧹 Đã dọn dẹp sạch sẽ các file .o và file thực thi!"

# Đánh dấu các target giả lập (không trùng tên với file vật lý)
.PHONY: all clean