;; Title: Restack (RESK)
;; Description: SIP-010 compliant token with a 1-time public airdrop claim.

;; Define the Fungible Token RESK with a max supply of 100,000
;; Note: Values are in micro-units (6 decimals)
(define-fungible-token RESK u100000000000)

;; Map to track addresses that have already claimed the airdrop
(define-map HasClaimed principal bool)

;; Error Constants
(define-constant ERR-ALREADY-CLAIMED (err u101))
(define-constant ERR-NOT-AUTHORIZED (err u102))

;; --- Public Functions ---

;; Claim Airdrop Function
;; Allows any user to claim 10 tokens once per lifetime.
(define-public (claim-airdrop)
    (let (
        (user tx-sender)
        ;; 10 tokens with 6 decimals = 10,000,000 micro-tokens
        (amount u10000000) 
    )
        ;; 1. Check if the user has already claimed
        (asserts! (is-none (map-get? HasClaimed user)) ERR-ALREADY-CLAIMED)
        
        ;; 2. Mint tokens to the user
        (try! (ft-mint? RESK amount user))
        
        ;; 3. Record that this user has claimed
        (map-set HasClaimed user true)
        
        (ok true)
    )
)

;; --- SIP-010 Standard Functions ---

;; Standard transfer function
(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
    (begin
        (asserts! (is-eq tx-sender sender) ERR-NOT-AUTHORIZED)
        (try! (ft-transfer? RESK amount sender recipient))
        (ok true)
    )
)

(define-read-only (get-name)
    (ok "Restack")
)

(define-read-only (get-symbol)
    (ok "RESK")
)

(define-read-only (get-decimals)
    (ok u6)
)

(define-read-only (get-balance (user principal))
    (ok (ft-get-balance RESK user))
)

(define-read-only (get-total-supply)
    (ok (ft-get-supply RESK))
)

(define-read-only (get-token-uri)
    (ok none)
)