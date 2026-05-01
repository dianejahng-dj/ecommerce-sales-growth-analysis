# 🛒 Brazilian E-commerce Sales Growth Analysis

> Validating 10 business hypotheses on 100K+ transactions from Brazil's largest marketplace to surface actionable marketing strategies.

---

## 📌 Project Overview

This project analyzes 2016–2018 transaction data from **Olist**, Brazil's largest multi-seller e-commerce platform, to identify what drives revenue growth and customer satisfaction.  
Working as a team, we formed 10 business hypotheses spanning pricing, logistics, payments, and geography — then tested each one with SQL and visualized findings to build concrete marketing recommendations.

---

## 🎯 Business Problem

> *"Which operational and behavioral factors most directly impact sales growth on the Olist platform — and what marketing actions should follow?"*

---

## 🗂 Dataset

**Source**: [Kaggle — Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)  
**Period**: 2016–2018  
**Size**: 100,000+ orders across 9 relational tables

| Table | Contents |
|-------|----------|
| `orders` | Order status, purchase & delivery timestamps |
| `order_items` | Product, seller, price, freight per line item |
| `order_payments` | Payment method, installments, value |
| `order_reviews` | Review score, comment, response date |
| `customers` | City, state, zip code |
| `sellers` | City, state, zip code |
| `products` | Category, dimensions, weight |
| `translation` | Portuguese → English category names |

---

## 🔬 Hypotheses & Key Findings

| # | Hypothesis | Result |
|---|-----------|--------|
| 1 | High-price category orders drive overall revenue | ✅ Watches/Gifts: 5,991 orders but revenue rivaled Beauty (9,670 orders) |
| 2 | High-review categories increase new customer conversion | ✅ Top-10 revenue categories avg score 4.42 vs. overall avg 4.04 |
| 3 | Top sellers differ meaningfully from others | ✅ Top 500 sellers = 78.2% of revenue; 13× more orders, 2.3× higher AOV |
| 4 | Larger gap between estimated & actual delivery → lower review score | ✅ Correlation –0.26; delayed delivery avg score 2.26 vs. early 4.29 |
| 5 | Cities with 1 customer have promotion potential | ✅ 1,176 cities (28.6%) with single customers — regional activation opportunity |
| 6 | Interest-free installments on credit cards would boost sales | ✅ Credit card = 78.3% of payments; 66.9% of those use installments |
| 7 | Boleto payment delays extend delivery time | ✅ Boleto avg delivery 13 days vs. debit card 10 days |
| 8 | Voucher user behavior patterns can guide marketing | ✅ High-spend voucher users identifiable for VIP targeting |
| 9 | High-revenue cities = high spend per customer | ❌ São Paulo ranks #15 in per-capita spend; Belém ranks #1 (435 customers) |
| 10 | Distance from São Paulo → longer delivery → lower review | ✅ Delivery–review correlation –0.85; RJ-based cities dominate low-score list |

---

## 💡 Marketing Recommendations

**1. Watches & Gifts — Seasonal Installment Campaign**  
Target Christmas (Dec) and Dia dos Namorados (Jun 12) with interest-free installment promotions on high-AOV categories.

**2. Logistics — Outer Region Fulfillment**  
Expand warehouse presence outside São Paulo. Introduce a subscription delivery model for outer-region customers to offset freight costs.

**3. Seller Development — Top Seller Benchmarking**  
Provide Other Sellers with training, in-platform advertising tools, and upsell guidance based on Top Seller behavior.

**4. Payment UX — Boleto Acceleration**  
Automate payment confirmation notifications and pre-stage shipping to reduce Boleto-related delays.

**5. Regional Activation — Single-Customer Cities**  
Deploy referral programs ("invite a friend" with mutual rewards) and first-purchase vouchers in the 1,176 single-customer cities.

**6. High-Spend City Targeting**  
Run new-member sign-up campaigns at Belém's major annual event *Círio de Nazaré* with vouchers redeemable on a second purchase.

---

## 🛠 Tools & Stack

![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat&logo=mysql&logoColor=white)
![DBeaver](https://img.shields.io/badge/DBeaver-382923?style=flat)
![Google Sheets](https://img.shields.io/badge/Google%20Sheets-34A853?style=flat&logo=google-sheets&logoColor=white)
![VSCode](https://img.shields.io/badge/VSCode-007ACC?style=flat&logo=visual-studio-code&logoColor=white)

---

## 📁 Repository Structure

```
ecommerce-sales-growth-analysis/
│
├── queries/
│   ├── hypothesis_01_category_revenue.sql
│   ├── hypothesis_02_review_conversion.sql
│   ├── hypothesis_03_seller_tiers.sql
│   ├── hypothesis_04_delivery_review.sql
│   ├── ...
│   └── hypothesis_10_distance_review.sql
│
├── charts/          # Exported visualizations (Google Sheets / Python)
├── report/          # Full project report (PDF)
└── README.md
```

---

## 👥 Team

5-person team project — Data Analytics Bootcamp, 2025
