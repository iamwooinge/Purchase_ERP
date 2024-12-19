# 김치 식자재 구매 및 관리 ERP 시스템
📖 **프로젝트 소개**</br>
김치 제조업체의 구매 및 자재 관리를 위한 효율적인 ERP(Enterprise Resource Planning) 플랫폼으로,</br>
이 시스템은 재료의 소요량을 계산하고 최적의 구매 계획을 수립하여 기업의 재고 관리와 비용 절감에 기여합니다.</br></br>

**프로젝트 기간**
- 2021.09 - 2021.12(14주)</br>
**참여 인원**
6명</br>
**기여도**
17%</br>
**담당 역할**
- 발주 등록 페이지 개발
- 청구 사항 불러오기 페이지 개발
- 데이터베이스 설계 및 구축, 서버 연동

**🚀 주요 기능**
**자재 소요량 계산 및 발주**</br>
- MRP(Material Requirements Planning) 기반의 소요량 계산</br>
- 데이터베이스와 연동된 재고 상태 실시간 확인</br></br>

**재고 및 구매 관리**</br>
- 발주, 입고, 교환/반품 내역 실시간 확인</br>
- 초기 재고 등록 및 실시간 재고 변화 추적</br></br>

**PDF 문서 저장 및 출력**</br>
- 청구서, 발주서 등 문서 자동 생성 및 PDF 저장 기능</br></br>

**부서별 권한 설정**
- 각 부서별 문서 접근 제한으로 데이터 무결성 보장</br></br>

**🛠️ 사용 기술**</br>
**[백엔드]**
- Java (DAO, DTO 패턴 활용)
- Apache Tomcat (서버 연동)
- MySQL (데이터베이스 설계 및 연동)

**[프론트엔드]**
- HTML, CSS, JavaScript (데이터 호출 및 UI 구현)
- JSP (페이지 동적 구성)
- Bootstrap (페이지 디자인 및 반응형 레이아웃)

**[기타]**
- PDF 생성 및 저장 기능 구현



**[결과물]**
## ERP 프로세스 설계서
![image](https://github.com/user-attachments/assets/160beacf-6c1f-416d-9948-00093f90c7ec)
## 부서 구성 및 역할
![image](https://github.com/user-attachments/assets/ac116194-4eb0-439a-95bb-75d45e34f04b)
## 비즈니스 규칙 및 데이터베이스 설계

### 주문번호
- 형식: 주문 일자(6자) - 품번.순번(4자)
- 예시: 주문 일자 2021년 9월 9일, 배추, 첫 번째 구매 → `210909-CB01`

---

### 품번

| 이름       | 영어                | 품번 | 이름          | 영어             | 품번 |
|------------|---------------------|------|---------------|------------------|------|
| 배추       | cabbage             | CB   | 무            | radish           | RD   |
| 고춧가루   | red pepper powder   | RP   | 마늘          | garlic           | GA   |
| 젓갈       | salted seafood      | SF   | 액젓          | fish sauce       | FS   |
| 소금       | salt                | SA   | 배            | pear             | PE   |
| 사과       | apple               | AP   | 아이스박스    | ice box          | IB   |
| 비닐       | vinyl               | VI   | 박스테이프    | box tape         | BT   |

---

### 거래처번호 (사업자 번호)

| 거래처명       | 거래처번호 (사업자번호)  | 제공 품목             |
|----------------|-------------------------|-----------------------|
| 싱싱청과       | 415-81-23845           | 배추, 무, 마늘        |
| 달콤청과       | 301-81-34757           | 사과, 배              |
| 저염상회       | 227-81-57439           | 소금, 액젓, 젓갈      |
| 고운 고춧가루  | 415-81-28597           | 고춧가루              |
| 서대문 포장    | 110-79-19574           | 아이스박스, 비닐, 박스테이프 |

---

### 데이터베이스 테이블

| 이름       | 테이블 이름        |
|------------|--------------------|
| 제품       | `product`          |
| 사원       | `employee`         |
| 거래처     | `clients`          |
| 청구       | `claim`            |
| 발주       | `orders`           |
| 입고       | `income`           |
| 재고       | `stock`            |
| 초기 재고  | `initialstock`     |
| MRP        | `mrp`              |

## 데이터베이스 ERD
![image](https://github.com/user-attachments/assets/9bbde97d-4d68-44aa-be02-a1229694369d)


## 화면
![image](https://github.com/user-attachments/assets/3f56bb45-79ee-4e66-a729-9304005d6340)
![image](https://github.com/user-attachments/assets/4db7f18f-3ee4-4613-834b-5caa166753e9)
![image](https://github.com/user-attachments/assets/c9b41c6c-0752-46be-9e82-73aae4c9192f)
![image](https://github.com/user-attachments/assets/89aaba68-058b-4d52-838b-770514a71c18)
![image](https://github.com/user-attachments/assets/fe8e49e1-732b-4e03-8a86-fe64a97714b5)
![image](https://github.com/user-attachments/assets/c97cde59-14d6-4a87-a3a7-71e045b0bfb7)
![image](https://github.com/user-attachments/assets/2d5a6ba8-b9c0-42eb-ae17-39bd656a09ec)
![image](https://github.com/user-attachments/assets/95d84714-afee-41c0-ab44-08e044158b3c)


