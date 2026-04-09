# Bhejdu Grocery App - Architecture & Workflow

## 1. App Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    BHEDU GROCERY APP                            │
│                      (Flutter/Dart)                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐            │
│  │   UI Layer  │  │  Logic Layer│  │  Data Layer │            │
│  │             │  │             │  │             │            │
│  │ • Screens   │  │ • Providers │  │ • API Calls │            │
│  │ • Widgets   │  │ • Models    │  │ • Local DB  │            │
│  │ • Themes    │  │ • Services  │  │ • SharedPref│            │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘            │
│         │                │                │                     │
│         └────────────────┴────────────────┘                     │
│                          │                                      │
│                   ┌──────▼──────┐                               │
│                   │   STATE     │                               │
│                   │ MANAGEMENT  │                               │
│                   │(SharedPrefs)│                               │
│                   └──────┬──────┘                               │
│                          │                                      │
└──────────────────────────┼──────────────────────────────────────┘
                           │
                           ▼ HTTP/JSON
┌─────────────────────────────────────────────────────────────────┐
│                     PHP BACKEND API                             │
│           (darkslategrey-chicken-274271.hostingersite.com)      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐            │
│  │  Auth API   │  │ Product API │  │  Order API  │            │
│  │  • login    │  │  • banners  │  │  • checkout │            │
│  │  • signup   │  │  • products │  │  • track    │            │
│  │  • otp      │  │  • search   │  │  • history  │            │
│  └─────────────┘  └─────────────┘  └─────────────┘            │
│                                                                 │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ▼ SQL
┌─────────────────────────────────────────────────────────────────┐
│                      MySQL DATABASE                             │
│  • users    • products  • orders  • addresses  • categories      │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. User Journey Flowchart

```
┌─────────┐
│  START  │
└────┬────┘
     │
     ▼
┌─────────────┐     ┌─────────────┐
│ Splash Screen│────▶│ Login/Signup │
└─────────────┘     └──────┬──────┘
                           │
              ┌────────────┼────────────┐
              │            │            │
              ▼            ▼            ▼
        ┌─────────┐  ┌─────────┐  ┌─────────┐
        │  Login  │  │  Signup │  │   OTP   │
        │  (Email)│  │(New User)│  │Verify   │
        └────┬────┘  └────┬────┘  └────┬────┘
             │            │            │
             └────────────┴────────────┘
                          │
                          ▼
                   ┌──────────────┐
                   │  HOME PAGE   │
                   │  • Banners   │
                   │  • Categories│
                   │  • Featured  │
                   └──────┬───────┘
                          │
          ┌───────────────┼───────────────┐
          │               │               │
          ▼               ▼               ▼
   ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
   │   Categories│ │   Product   │ │   Profile   │
   │   • Browse  │ │   Details   │ │   • Orders  │
   │   • Filter  │ │   • Variants│ │   • Wallet  │
   │   • Search  │ │   • Reviews │ │   • Address │
   └──────┬──────┘ └──────┬──────┘ └──────┬──────┘
          │               │               │
          │               ▼               │
          │        ┌─────────────┐        │
          │        │ ADD TO CART │        │
          │        │  • Quantity │        │
          │        │  • Price    │        │
          │        └──────┬──────┘        │
          │               │               │
          └───────────────┼───────────────┘
                          ▼
                   ┌─────────────┐
                   │  CART PAGE  │
                   │ • View Items│
                   │ • Edit Qty  │
                   │ • Remove    │
                   └──────┬──────┘
                          ▼
                   ┌─────────────┐
                   │   CHECKOUT  │
                   │ • Address   │
                   │ • Payment   │
                   │ • Place Order│
                   └──────┬──────┘
                          ▼
                   ┌─────────────┐
                   │ORDER PLACED │
                   │  SUCCESS!   │
                   │ • Track     │
                   │ • Continue  │
                   └─────────────┘
```

---

## 3. Feature Modules

```
┌────────────────────────────────────────────────────────────┐
│                    APP FEATURES                             │
├────────────────────────────────────────────────────────────┤
│                                                             │
│  🔐 AUTHENTICATION          🛒 SHOPPING                     │
│  ├─ Login (Email/Pass)      ├─ Browse Categories          │
│  ├─ Signup (New User)       ├─ Product Search             │
│  ├─ OTP Verification        ├─ Add to Cart                 │
│  └─ Password Reset          ├─ View Cart                   │
│                             ├─ Update Quantity             │
│  🏠 ADDRESS MANAGEMENT      └─ Remove Items                │
│  ├─ Add New Address                                         │
│  ├─ Edit Address           💳 CHECKOUT                     │
│  ├─ Delete Address          ├─ Select Address              │
│  └─ Set Default             ├─ Payment Method              │
│                             ├─ Apply Coupon                │
│  📦 ORDERS                  └─ Place Order                 │
│  ├─ Order History                                          │
│  ├─ Track Order            👤 USER PROFILE                 │
│  ├─ Order Details           ├─ View Profile                 │
│  └─ Reorder                 ├─ Edit Profile                │
│                             ├─ Order History               │
│  🔔 NOTIFICATIONS           ├─ Wallet                      │
│  ├─ Order Updates           └─ Logout                     │
│  └─ Promotions                                             │
│                                                             │
└────────────────────────────────────────────────────────────┘
```

---

## 4. API Integration Flow

```
┌────────────────────────────────────────────────────────────┐
│                    API INTEGRATION                          │
├────────────────────────────────────────────────────────────┤
│                                                             │
│  BASE URL: https://darkslategrey-chicken-274271.hostingersite.com/api
│                                                             │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐   │
│  │   AUTH      │    │   PRODUCT   │    │   ORDER     │   │
│  ├─────────────┤    ├─────────────┤    ├─────────────┤   │
│  │ POST /login │    │ GET /banners│    │POST/checkout│   │
│  │ POST /signup│    │ GET /cats   │    │GET /orders  │   │
│  │ POST /verify│    │ GET /prods  │    │GET /track   │   │
│  │POST /forgot │    │GET /search  │    │             │   │
│  └─────────────┘    └─────────────┘    └─────────────┘   │
│                                                             │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐   │
│  │   ADDRESS   │    │   PROFILE   │    │   USER      │   │
│  ├─────────────┤    ├─────────────┤    ├─────────────┤   │
│  │POST /add    │    │GET /profile │    │PUT /update  │   │
│  │GET /list    │    │PUT /update  │    │GET /wallet  │   │
│  │PUT /edit    │    │POST /image  │    │             │   │
│  │DEL /delete  │    │             │    │             │   │
│  └─────────────┘    └─────────────┘    └─────────────┘   │
│                                                             │
│  REQUEST FORMAT:           RESPONSE FORMAT:                │
│  {                           {                             │
│    "user_id": 123,             "status": "success",        │
│    "param": "value"            "message": "...",             │
│  }                             "data": {...}               │
│                              }                             │
│                                                             │
└────────────────────────────────────────────────────────────┘
```

---

## 5. Tech Stack Visualization

```
┌────────────────────────────────────────────────────────────┐
│                    TECH STACK                               │
├────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────┐        ┌─────────────────┐            │
│  │    FRONTEND     │◄──────►│     BACKEND     │            │
│  │                 │        │                 │            │
│  │  Flutter/Dart   │  HTTP  │  PHP REST API   │            │
│  │  Dart 3.x       │  JSON  │  PHP 8.x        │            │
│  │  Material UI    │        │  RESTful        │            │
│  │  Provider       │        │  JWT Auth       │            │
│  └────────┬────────┘        └────────┬────────┘            │
│           │                          │                      │
│           ▼                          ▼                      │
│  ┌─────────────────┐        ┌─────────────────┐         │
│  │  STATE STORAGE  │        │    DATABASE     │         │
│  │                 │        │                 │         │
│  │ SharedPreferences│       │  MySQL 8.x      │         │
│  │ Local Storage   │        │  Relational     │         │
│  └─────────────────┘        └─────────────────┘         │
│                                                             │
│  EXTERNAL SERVICES:                                         │
│  • Twilio SMS (OTP) - Currently using "Skip OTP" for testing│
│  • Image Hosting - Cloud server for product images            │
│                                                             │
└────────────────────────────────────────────────────────────┘
```

---

## How to Use These Diagrams

### For LinkedIn:
1. Copy any diagram above
2. Use a Mermaid renderer like:
   - [Mermaid Live Editor](https://mermaid.live)
   - [GitHub Mermaid support](https://github.blog/2022-02-14-include-diagrams-markdown-files-mermaid/)
   - VS Code with Mermaid extension

### Convert to Image:
```bash
# Install mermaid-cli
npm install -g @mermaid-js/mermaid-cli

# Generate PNG
mmdc -i WORKFLOW_DIAGRAM.md -o diagram.png
```

### Screenshot Tools:
- Windows: Win + Shift + S
- Mac: Cmd + Shift + 4
- Online: [Carbon](https://carbon.now.sh) for code snippets

---

## Key Features to Highlight on LinkedIn

🚀 **Full-Stack Grocery Delivery App**

✅ Flutter frontend with beautiful UI/UX
✅ PHP REST API backend
✅ MySQL database with relational structure
✅ Complete user authentication flow
✅ Shopping cart with real-time updates
✅ Address management system
✅ Order tracking functionality
✅ Wallet & payment integration

**Perfect for showcasing full-stack mobile development skills!**

---

*Generated for Bhejdu Grocery App*  
*GitHub: https://github.com/vizz-bob/Grocery-App*
