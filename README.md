# IP Fraud Checker cho dải IP tùy chỉnh

Tool Python này dùng để kiểm tra định kỳ `fraud score` của các địa chỉ IP trong một dải subnet thông qua dịch vụ [IP2Location](https://www.ip2location.com/), sau đó xuất kết quả ra file Excel.

Tool hiện hỗ trợ cấu hình subnet theo 3 mức ưu tiên:

1. truyền trực tiếp bằng tham số `--subnet`
2. sửa file `config.json`
3. nếu không có 2 cách trên thì dùng `DEFAULT_SUBNET` trong code

Tool hỗ trợ 2 cách lấy dữ liệu:

1. **API IP2Location.io**
   - Nhanh hơn
   - Ổn định hơn
   - Phù hợp khi chạy định kỳ lâu dài
   - Cần API key

2. **Web scraping từ trang demo IP2Location**
   - Không cần API key
   - Dễ dùng ngay
   - Chậm hơn API
   - Có thể bị giới hạn nếu chạy quá nhiều

## 1. Tính năng chính

- Random từ **10 đến 20 IP** trong dải subnet đang cấu hình
- Hoặc kiểm tra **toàn bộ IP host** trong dải
- Lấy các thông tin chính:
  - IP Address
  - Fraud Score
  - Is Proxy
  - Country
  - Region
  - City
  - ISP
  - Usage Type
  - Proxy Type
  - Threat
- Xuất kết quả ra file **Excel `.xlsx`**
- Có **sheet tổng hợp Summary**
- Hỗ trợ **chạy định kỳ theo số phút**
- Có thể đổi sang dải IP khác trong code hoặc qua CLI

## 2. Cấu trúc file

Các file chính trong thư mục:

- [ip_fraud_checker.py](ip_fraud_checker.py): file Python chính của tool
- [config.json](config.json): file cấu hình subnet mặc định không cần sửa code
- [setup.bat](setup.bat): script cài đặt môi trường và package
- [requirements.txt](requirements.txt): danh sách package cần cài
- [output/](output): nơi chứa file Excel kết quả sau khi chạy

## 3. Yêu cầu hệ thống

- Windows
- Python 3.10 trở lên
- Có kết nối Internet

Khuyến nghị:

- Dùng Python 3.12
- Có tài khoản IP2Location.io nếu muốn chạy ổn định bằng API

## 4. Cài đặt nhanh

### Cách 1: Dùng file `setup.bat` (khuyến nghị)

Chỉ cần chạy file [setup.bat](setup.bat).

#### Cách chạy:

1. Mở thư mục project
2. Click đúp file `setup.bat`

hoặc mở `Command Prompt` / `PowerShell` rồi chạy:

```bat
setup.bat
```

Script sẽ tự động:

- Kiểm tra Python đã được cài chưa
- Tạo môi trường ảo `.venv`
- Nâng cấp `pip`
- Cài tất cả package từ `requirements.txt`
- Hiển thị hướng dẫn kích hoạt môi trường sau khi cài xong

---

### Cách 2: Cài đặt thủ công

#### Bước 1: Tạo môi trường ảo

```bat
python -m venv .venv
```

#### Bước 2: Kích hoạt môi trường ảo

**Command Prompt:**

```bat
.venv\Scripts\activate.bat
```

**PowerShell:**

```powershell
.\.venv\Scripts\Activate.ps1
```

#### Bước 3: Nâng cấp pip

```bat
python -m pip install --upgrade pip
```

#### Bước 4: Cài package

```bat
pip install -r requirements.txt
```

## 5. Package sử dụng

Tool cần các package sau:

- `requests`
- `beautifulsoup4`
- `lxml`
- `openpyxl`

## 6. Cách sử dụng

### 6.1. Chạy mặc định

Lệnh dưới đây sẽ:

- random từ 10 đến 20 IP trong dải lấy từ `config.json` nếu có
- nếu `config.json` không có giá trị thì dùng `DEFAULT_SUBNET` trong code
- dùng chế độ scraping
- xuất ra file Excel

```bat
python ip_fraud_checker.py
```

---

### 6.2. Chỉ định số lượng IP cần kiểm tra

Ví dụ kiểm tra 15 IP ngẫu nhiên:

```bat
python ip_fraud_checker.py --count 15
```

---

### 6.3. Dùng API key của IP2Location.io

Nếu có API key, nên dùng cách này vì:

- nhanh hơn
- ổn định hơn
- ít phụ thuộc giao diện website

Ví dụ:

```bat
python ip_fraud_checker.py --api-key YOUR_API_KEY
```

Hoặc set biến môi trường trước:

```bat
set IP2LOCATION_API_KEY=YOUR_API_KEY
python ip_fraud_checker.py
```

---

### 6.4. Kiểm tra toàn bộ IP trong dải

```bat
python ip_fraud_checker.py --all --api-key YOUR_API_KEY
```

Lưu ý:

- Nên dùng `--api-key` khi chạy `--all`
- Nếu dùng scraping để quét toàn bộ, thời gian sẽ lâu và có nguy cơ bị giới hạn request

---

### 6.5. Chạy theo lịch định kỳ

Ví dụ chạy mỗi 60 phút:

```bat
python ip_fraud_checker.py --schedule 60
```

Ví dụ chạy mỗi 30 phút bằng API:

```bat
python ip_fraud_checker.py --schedule 30 --api-key YOUR_API_KEY
```

---

### 6.6. Đổi dải IP cần kiểm tra

#### Cách 1: Sửa `config.json` (khuyến nghị)

Mở file [config.json](config.json) và sửa giá trị:

```json
{
   "default_subnet": "103.94.16.0/24"
}
```

Ví dụ đổi sang dải khác:

```json
{
   "default_subnet": "10.10.10.0/24"
}
```

Sau đó chạy lại:

```bat
python ip_fraud_checker.py
```

Tool sẽ tự lấy subnet mới từ `config.json` mà không cần sửa code.

#### Cách 2: Sửa trực tiếp trong code

Mở file [ip_fraud_checker.py](ip_fraud_checker.py) và sửa dòng cấu hình mặc định:

```python
DEFAULT_SUBNET = "103.94.16.0/24"
```

Ví dụ nếu muốn đổi sang dải khác:

```python
DEFAULT_SUBNET = "10.10.10.0/24"
```

Sau khi sửa, chỉ cần chạy lại:

```bat
python ip_fraud_checker.py
```

Khi đó tool sẽ dùng dải mới làm mặc định nếu `config.json` không có giá trị và bạn không truyền `--subnet`.

#### Cách 3: Truyền trực tiếp khi chạy

```bat
python ip_fraud_checker.py --subnet 10.10.10.0/24
```

Tham số này sẽ ghi đè cả `config.json` lẫn `DEFAULT_SUBNET` chỉ cho lần chạy hiện tại.

---

### 6.7. Chỉ định tên file output

```bat
python ip_fraud_checker.py --count 10 --output output\bao_cao_fraud.xlsx
```

## 7. Các tham số hỗ trợ

| Tham số | Ý nghĩa |
|---|---|
| `--api-key` | API key của IP2Location.io |
| `--count` | Số lượng IP random cần kiểm tra |
| `--all` | Kiểm tra toàn bộ IP trong dải |
| `--subnet` | Dải IP cần kiểm tra |
| `--schedule` | Chạy định kỳ mỗi N phút |
| `--output` | Đường dẫn file Excel đầu ra |

## 8. Ví dụ thực tế

### Ví dụ 1: Chạy nhanh 10 IP bằng scraping

```bat
python ip_fraud_checker.py --count 10 --subnet 10.10.10.0/24
```

### Ví dụ 2: Chạy 20 IP bằng API

```bat
python ip_fraud_checker.py --count 20 --api-key YOUR_API_KEY --subnet 10.10.10.0/24
```

### Ví dụ 3: Chạy toàn bộ dải IP và lưu file riêng

```bat
python ip_fraud_checker.py --all --api-key YOUR_API_KEY --subnet 10.10.10.0/24 --output output\full_scan.xlsx
```

### Ví dụ 4: Chạy định kỳ mỗi 2 giờ

```bat
python ip_fraud_checker.py --schedule 120 --api-key YOUR_API_KEY --subnet 10.10.10.0/24
```

## 9. File kết quả Excel

Sau khi chạy xong, tool sẽ tạo file Excel trong thư mục [output/](output).

Tên file mặc định có dạng:

```text
ip_fraud_scores_YYYYMMDD_HHMMSS.xlsx
```

File Excel gồm 2 sheet:

### Sheet 1: `IP Fraud Scores`

Chứa danh sách chi tiết từng IP:

- STT
- IP Address
- Fraud Score
- Is Proxy
- Country
- Region
- City
- ISP
- Usage Type
- Proxy Type
- Threat
- Is VPN
- Is TOR
- Is Data Center
- Method

### Sheet 2: `Summary`

Chứa thống kê tổng quan:

- Tổng số IP kiểm tra
- Số IP lấy được fraud score
- Fraud score thấp nhất
- Fraud score cao nhất
- Fraud score trung bình
- Phân loại theo mức độ rủi ro

## 10. Mức độ đánh giá fraud score

Tool đang tô màu fraud score trong Excel theo mức sau:

- `0 - 20`: Low Risk
- `21 - 50`: Medium Risk
- `51 - 80`: High Risk
- `81 - 100`: Critical

## 11. Đăng ký API key miễn phí

Có thể đăng ký API key miễn phí tại:

- https://www.ip2location.io/sign-up

Theo thông tin từ trang dịch vụ, gói free có thể đủ cho nhu cầu kiểm tra nhỏ hằng ngày.

## 12. Nên dùng API hay scraping?

### Nên dùng API nếu:

- muốn chạy định kỳ lâu dài
- muốn tốc độ nhanh hơn
- muốn ổn định hơn
- muốn quét số lượng IP nhiều hơn

### Dùng scraping nếu:

- muốn test nhanh
- chưa có API key
- chỉ kiểm tra ít IP

## 13. Một số lưu ý quan trọng

- Thứ tự ưu tiên cấu hình subnet là: `--subnet` -> `config.json` -> `DEFAULT_SUBNET` trong code.
- Tool scraping phụ thuộc vào cấu trúc HTML của website. Nếu website thay đổi giao diện, phần scraping có thể cần cập nhật.
- Khi chạy quá nhiều request liên tiếp bằng scraping, website có thể giới hạn truy cập tạm thời.
- Khi dùng `--all`, nên ưu tiên API để tiết kiệm thời gian.
- Nếu chạy định kỳ trên máy chủ, nên kết hợp với `Task Scheduler` của Windows.

## 14. Cách chạy bằng Task Scheduler trên Windows

Có thể tạo tác vụ chạy định kỳ như sau:

1. Mở **Task Scheduler**
2. Chọn **Create Basic Task**
3. Đặt tên task, ví dụ: `IP Fraud Checker`
4. Chọn chu kỳ chạy
5. Ở phần Action, chọn **Start a Program**
6. Program/script:

```text
D:\WORKSPACE\Translate_Tool\.venv\Scripts\python.exe
```

7. Add arguments:

```text
D:\WORKSPACE\Translate_Tool\ip_fraud_checker.py --schedule 60 --api-key YOUR_API_KEY
```

Hoặc nếu không dùng `--schedule`, có thể để Task Scheduler tự gọi mỗi giờ một lần:

```text
D:\WORKSPACE\Translate_Tool\ip_fraud_checker.py --count 15 --api-key YOUR_API_KEY
```

## 15. Xử lý lỗi thường gặp

### Lỗi: `python is not recognized`

Nguyên nhân: chưa cài Python hoặc Python chưa có trong `PATH`.

Cách xử lý:

- cài Python từ trang chính thức
- chọn tùy chọn **Add Python to PATH** khi cài

### Lỗi: không kích hoạt được PowerShell script

Nếu PowerShell chặn script:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

### Lỗi: scraping không lấy được dữ liệu

Nguyên nhân có thể do:

- website thay đổi giao diện
- mạng bị chặn
- IP bị rate limit

Cách xử lý tốt nhất:

- dùng `--api-key`
- giảm tần suất chạy
- giảm số IP mỗi lần quét

## 16. Gợi ý vận hành thực tế

Nếu mục tiêu là kiểm tra định kỳ fraud score cho một dải IP nội bộ hoặc dải IP public của bạn, cách chạy phù hợp là:

### Phương án nhẹ:

- mỗi 1 giờ random 10-20 IP
- dùng API key nếu có

Ví dụ:

```bat
python ip_fraud_checker.py --schedule 60 --count 15 --api-key YOUR_API_KEY
```

### Phương án đầy đủ:

- mỗi ngày quét toàn bộ dải IP 1 lần
- dùng API
- lưu kết quả theo ngày để so sánh

Ví dụ:

```bat
python ip_fraud_checker.py --all --api-key YOUR_API_KEY --output output\daily_scan.xlsx
```

## 17. Tác giả / ghi chú

README này được viết để hỗ trợ triển khai nhanh nội bộ, ưu tiên dễ hiểu, dễ dùng, dễ bàn giao.

Nếu muốn mở rộng thêm, có thể phát triển tiếp các tính năng như:

- so sánh kết quả giữa các lần chạy
- cảnh báo khi fraud score tăng cao
- gửi email / Telegram / Teams khi phát hiện IP rủi ro
- lưu lịch sử vào database
