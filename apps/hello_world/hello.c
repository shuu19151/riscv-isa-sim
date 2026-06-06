// Khai báo biến tohost được định nghĩa từ file assembly/linker
extern volatile unsigned long long tohost;
extern volatile unsigned long long fromhost;

#define DEV_CMD_POWEROFF 0
#define DEV_CMD_PRINT 1

// Hàm gửi 1 ký tự ra màn hình của Spike
void put_char(char c) {
    // Spike HTIF yêu cầu gửi dữ liệu theo định dạng: 
    // Device (8-bit) | Command (8-bit) | Payload (48-bit)
    // Thiết bị 1 là Console, Lệnh 1 là Xuất ký tự
    unsigned long long magic = ((unsigned long long)DEV_CMD_PRINT << 56) | 
                               ((unsigned long long)DEV_CMD_PRINT << 48) | 
                               (unsigned char)c;
    
    // Đợi cho đến khi Spike xử lý xong lệnh trước đó (tohost về 0)
    while (tohost != 0);
    
    // Ghi lệnh mới vào tohost để Spike in ra màn hình
    tohost = magic;
}

// Hàm in một chuỗi ký tự
void print_string(const char *str) {
    while (*str) {
        put_char(*str);
        str++;
    }
}

// Hàm gửi lệnh tắt trình giả lập Spike (tránh bị lặp vô hạn)
void poweroff(void) {
    while (tohost != 0);
    // Thiết bị 0, Lệnh 0, Payload 0 => Lệnh tắt máy thành công
    tohost = 1; 
    while (1);
}

int main(void) {
    print_string("Hello World từ RISC-V Bare-Metal!");
    put_char('\n'); 
    
    // Thoát khỏi trình giả lập Spike
    poweroff();
    
    return 0;
}