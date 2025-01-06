# 김치 식자재 구매 및 관리 ERP 시스템
## 📖 **프로젝트 소개**</br>
김치 제조업체의 구매 및 자재 관리를 위한 효율적인 ERP(Enterprise Resource Planning) 플랫폼으로,<br>
재료의 소요량을 계산하고 최적의 구매 계획을 수립하여 기업의 재고 관리와 비용 절감에 기여합니다.<br>

- **이름**: 서대문 김치명가
- **목표**:
  - 자재 소요량 산출, 최적의 자재 구매 계획 수립
  - 자재 입고와 출고를 통계적으로 관리하여 기업의 이윤 창출에 이바지
  - 식자재 및 재료 수급 과정에서 효율적인 관리에 따른 재고량 감소
  - 제품 생산 계획에 따른 재료 수급의 효율 향상
  - 자재 수급에 따른 실시간 재고량 확인
- **기간**: 2021.09 - 2021.12(14주)<br>
- **참여 인원**: 6명


## 🚀주요 기능
### 1. 자재 소요량 계산 및 발주</br>
- MRP(Material Requirements Planning) 기반의 소요량 계산</br>
- 데이터베이스와 연동된 재고 상태 실시간 확인

### 2. 재고 및 구매 관리</br>
- 발주, 입고, 교환/반품 내역 실시간 확인</br>
- 초기 재고 등록 및 실시간 재고 변화 추적

### 3. PDF 문서 저장 및 출력</br>
- 청구서, 발주서 등 문서 자동 생성 및 PDF 저장 기능

### 4. 부서별 권한 설정
- 각 부서별 문서 접근 제한으로 데이터 무결성 보장</br></br>

## 🛠️ 사용 기술</br>
### 백엔드
- Java (DAO, DTO 패턴 활용)
- Apache Tomcat (서버 연동)
- MySQL (데이터베이스 설계 및 연동)

### 프론트엔드
- HTML, CSS, JavaScript (데이터 호출 및 UI 구현)
- JSP (페이지 동적 구성)
- Bootstrap (페이지 디자인 및 반응형 레이아웃)

### 기타
- PDF 생성 및 저장 기능 구현


## 결과물
### ERP 프로세스 설계서
![image](https://github.com/user-attachments/assets/160beacf-6c1f-416d-9948-00093f90c7ec)
### 부서 구성 및 역할
![image](https://github.com/user-attachments/assets/ac116194-4eb0-439a-95bb-75d45e34f04b)
### 비즈니스 규칙 및 데이터베이스 설계

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

### 데이터베이스 ERD
![image](https://github.com/user-attachments/assets/9bbde97d-4d68-44aa-be02-a1229694369d)


### 서비스 화면

#### 메인 화면
- 자사를 대표하는 식자재를 강조하고 자사에 대한 정보 기재
![메인](https://github.com/user-attachments/assets/9eaacf6b-5a03-4662-80c2-44484637f724)

#### 로그인 화면
- 로그인 실패 시 경고창 기능 구현
![로그인](https://github.com/user-attachments/assets/87d138e1-afa6-4170-a5d6-77d34b2ebf87)

#### 청구 등록 화면
- 식품 제작 의뢰가 들어온 후, 발주 부서에 자재를 청구하기 위한 페이지
- MRP 프로세스를 이용하여 필요량에 따른 소요량 계산
- 데이터베이스에 등록된 물품을 선택하면 자동으로 지정된 규격/단위 출력
- 필요량 기재 후 저장할 시 데이터베이스에 등록
![청구등록](https://github.com/user-attachments/assets/b6e08647-d2ea-4a51-b504-3aa6e7b44830)

#### 청구 현황 화면
- 등록된 청구 현황 확인 가능
![청구현황](https://github.com/user-attachments/assets/cedecd9a-6a2a-4031-952a-db793260604a)

#### 발주 등록 화면
- 청구 부서에서 등록한 데이터를 바탕으로 거래처에 발주하기 위한 페이지
- 물품마다 면세/과세 및 금액 자동 계산 후 데이터베이스에 등록
- 거래처에 발송할 발주서 확인 및 저장
![발주등록](https://github.com/user-attachments/assets/39979767-d15b-427d-9794-6a90757e30a8)

#### 발주 현황 화면
- 등록된 발주 현황 확인 가능
![발주현황](https://github.com/user-attachments/assets/d563430d-dedc-4444-852b-5faacd18ca6d)

#### 입고 등록 화면
- 발주가 완료되어 자사로 들어온 물품 수량을 관리하는 페이지
- 입고, 교환/반품과 같이 입고 유형에 따른 물품 처리 가능
![입고등록](https://github.com/user-attachments/assets/bc20caa7-c3d7-4091-a0f9-b663f58d5976)

#### 입고 현황 화면
- 등록된 입고 현황 및 교환/반품 현황 확인 가능
![입고현황](https://github.com/user-attachments/assets/473da660-2c20-454b-a895-2009e6170589)

#### 초기 재고 등록 화면
- 초기 재고를 등록하고 확인하는 페이지
![초기 재고 등록](https://github.com/user-attachments/assets/d955af8d-84e3-498f-92c1-7c940f6d16bb)

#### 재고 현황 화면
- 입고 페이지에서 입고가 모두 완료되었을 때, 실시간으로 변화된 재고량 확인 가능
![재고현황](https://github.com/user-attachments/assets/0a982f6e-0df2-488c-b028-0b34b72e3286)
#### 문서(발주서, 물품 구매 내역서, 물품 구매 신청서)
- 다른 부서에서 작성된 데이터 불러오기 기능
- 선택된 데이터 항목을 문서화 및 저장 기능
![문서](https://github.com/user-attachments/assets/f9a18583-62a4-4779-9910-cd07c6111a80)