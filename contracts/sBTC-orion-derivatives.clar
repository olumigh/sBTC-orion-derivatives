;; sBTC-orion-derivatives

;; Description: Implementation of core derivatives trading functionality

;; -----------------------------
;; Constants and Traits
;; -----------------------------

;; Define error codes
(define-constant ERR-UNAUTHORIZED (err u100))
(define-constant ERR-INVALID-AMOUNT (err u101))
(define-constant ERR-INSUFFICIENT-BALANCE (err u102))
(define-constant ERR-INVALID-POSITION (err u103))
(define-constant ERR-INSUFFICIENT-COLLATERAL (err u104))

;; Minimum collateral ratio (150%)
(define-constant MIN-COLLATERAL-RATIO u150)

;; Position types
(define-constant TYPE-LONG u1)
(define-constant TYPE-SHORT u2)

;; -----------------------------
;; Data Maps and Variables
;; -----------------------------

;; Track user balances
(define-map balances 
    principal 
    { stx-balance: uint })

;; Track positions
(define-map positions 
    uint 
    { owner: principal,
      position-type: uint,
      size: uint,
      entry-price: uint,
      leverage: uint,
      collateral: uint,
      liquidation-price: uint })

;; Position counter
(define-data-var position-counter uint u0)

;; Contract admin
(define-data-var contract-owner principal tx-sender)

;; Price oracle (simplified for testnet)
(define-data-var current-price uint u0)

;; -----------------------------
;; Read-Only Functions
;; -----------------------------

(define-read-only (get-balance (user principal))
    (default-to 
        { stx-balance: u0 }
        (map-get? balances user)))

(define-read-only (get-position (position-id uint))
    (map-get? positions position-id))

(define-read-only (get-current-price)
    (ok (var-get current-price)))

;; Calculate liquidation price
(define-read-only (calculate-liquidation-price 
    (entry-price uint) 
    (position-type uint) 
    (leverage uint))
    (if (is-eq position-type TYPE-LONG)
        ;; Long position liquidation price
        (ok (/ (* entry-price (- u100 (/ u100 leverage))) u100))
        ;; Short position liquidation price
        (ok (/ (* entry-price (+ u100 (/ u100 leverage))) u100))))

;; -----------------------------
;; Public Functions
;; -----------------------------

;; Deposit collateral
(define-public (deposit-collateral (amount uint))
    (let ((current-balance (get stx-balance (get-balance tx-sender))))
        (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
        (ok (map-set balances 
            tx-sender 
            { stx-balance: (+ current-balance amount) }))))
