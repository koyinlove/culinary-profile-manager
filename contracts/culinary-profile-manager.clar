;; culinary-profile-manager.clar - Culinary Profile Manager Contract
;;
;; This smart contract enables users to create and manage personalized culinary profiles on the blockchain.
;; Each culinary profile contains:
;;   - Chef Name: The user's preferred name in the culinary community
;;   - Experience Level: Years of cooking experience (numerical value)
;;   - Cuisine Specialties: Types of cuisine the user specializes in or enjoys preparing
;;   - Signature Dishes: The user's favorite or most accomplished recipes
;;   - Recipe Collection: Documented recipes the user has prepared successfully
;;
;; The contract provides comprehensive validation for all profile elements and
;; enables users to query specific aspects of their or other chefs' profiles.

;; Primary data structure: Map storing culinary profiles keyed by principal address
(define-map chef-profiles
    principal  ;; Chef's principal address serves as the unique identifier
    {
        chef-name: (string-ascii 100),               ;; Chef's name (maximum 100 characters)
        experience-level: uint,                      ;; Years of cooking experience (integer)
        cuisine-specialties: (list 10 (string-ascii 50)),  ;; List of cuisine specialties (maximum 10, each up to 50 characters)
        signature-dishes: (list 5 (string-ascii 100)),  ;; List of signature dishes (maximum 5, each up to 100 characters)
        recipe-collection: (list 5 (string-ascii 100))   ;; List of recipes in collection (maximum 5, each up to 100 characters)
    }
)

;; Error code definitions for enhanced user feedback and contract stability
(define-constant ERR-PROFILE-NOT-FOUND (err u404))  ;; Error when requested profile doesn't exist
(define-constant ERR-PROFILE-EXISTS (err u409))     ;; Error when attempting to create duplicate profile
(define-constant ERR-INVALID-EXPERIENCE (err u400)) ;; Error for invalid experience level values
(define-constant ERR-INVALID-CHEF-NAME (err u401))  ;; Error when chef name format is invalid
(define-constant ERR-INVALID-DISH (err u402))       ;; Error for invalid dish entries
(define-constant ERR-INVALID-CUISINE (err u403))    ;; Error when cuisine specialties are invalid
(define-constant ERR-INVALID-RECIPE (err u404))     ;; Error for improperly formatted recipe entries

;; Function to create a new culinary profile with validation
(define-public (create-chef-profile 
    (chef-name (string-ascii 100))           ;; Chef's preferred culinary name
    (experience-level uint)                  ;; Years of cooking experience
    (cuisine-specialties (list 10 (string-ascii 50)))  ;; Cuisine types specialized in
    (signature-dishes (list 5 (string-ascii 100)))     ;; Special dishes mastered
    (recipe-collection (list 5 (string-ascii 100))))   ;; Recipes prepared successfully
    (let
        (
            (kitchen-owner tx-sender)  ;; Get the transaction sender's address
            (existing-chef-profile (map-get? chef-profiles kitchen-owner))  ;; Check for existing profile
        )
        ;; Verify the chef doesn't already have a profile registered
        (if (is-none existing-chef-profile)
            (begin
                ;; Comprehensive input validation for all profile elements
                (if (or (is-eq chef-name "")
                        (< experience-level u2)                ;; Minimum 2 years experience required
                        (> experience-level u75)               ;; Maximum reasonable experience cap
                        (is-eq (len signature-dishes) u0)      ;; At least one signature dish required
                        (is-eq (len cuisine-specialties) u0)   ;; At least one cuisine specialty required
                        (is-eq (len recipe-collection) u0))    ;; At least one recipe in collection required
                    (err ERR-INVALID-EXPERIENCE)  ;; Return appropriate validation error
                    (begin
                        ;; Store validated profile in the chef-profiles map
                        (map-set chef-profiles kitchen-owner
                            {
                                chef-name: chef-name,
                                experience-level: experience-level,
                                cuisine-specialties: cuisine-specialties,
                                signature-dishes: signature-dishes,
                                recipe-collection: recipe-collection
                            }
                        )
                        (ok "Culinary profile successfully created and stored on-chain.")  ;; Success confirmation
                    )
                )
            )
            (err ERR-PROFILE-EXISTS)  ;; Error if chef already has a profile
        )
    )
)

;; Function to modify an existing culinary profile with comprehensive input validation
(define-public (modify-chef-profile
    (chef-name (string-ascii 100))           ;; Updated chef name
    (experience-level uint)                  ;; Updated experience level
    (cuisine-specialties (list 10 (string-ascii 50)))  ;; Updated cuisine specialties
    (signature-dishes (list 5 (string-ascii 100)))     ;; Updated signature dishes
    (recipe-collection (list 5 (string-ascii 100))))   ;; Updated recipe collection
    (let
        (
            (kitchen-owner tx-sender)  ;; Get the transaction sender's address
            (existing-chef-profile (map-get? chef-profiles kitchen-owner))  ;; Verify profile exists
        )
        ;; Confirm the chef profile exists before attempting modification
        (if (is-some existing-chef-profile)
            (begin
                ;; Comprehensive validation of updated profile information
                (if (or (is-eq chef-name "")
                        (< experience-level u2)                ;; Minimum experience requirement
                        (> experience-level u75)               ;; Maximum reasonable experience
                        (is-eq (len signature-dishes) u0)      ;; Must include at least one signature dish
                        (is-eq (len cuisine-specialties) u0)   ;; Must include at least one cuisine specialty
                        (is-eq (len recipe-collection) u0))    ;; Must include at least one recipe
                    (err ERR-INVALID-EXPERIENCE)  ;; Return appropriate validation error
                    (begin
                        ;; Update the chef's profile with new information
                        (map-set chef-profiles kitchen-owner
                            {
                                chef-name: chef-name,
                                experience-level: experience-level,
                                cuisine-specialties: cuisine-specialties,
                                signature-dishes: signature-dishes,
                                recipe-collection: recipe-collection
                            }
                        )
                        (ok "Culinary profile updated with latest information.")  ;; Success confirmation
                    )
                )
            )
            (err ERR-PROFILE-NOT-FOUND)  ;; Error if no profile exists for modification
        )
    )
)

;; Read-only function to retrieve a complete chef profile by principal address
(define-read-only (retrieve-chef-profile (chef-address principal))
    (match (map-get? chef-profiles chef-address)
        profile (ok profile)  ;; Return the complete profile if found
        ERR-PROFILE-NOT-FOUND  ;; Return error if profile doesn't exist
    )
)

;; Read-only function to retrieve only a chef's cuisine specialties
(define-read-only (retrieve-cuisine-specialties (chef-address principal))
    (match (map-get? chef-profiles chef-address)
        profile (ok (get cuisine-specialties profile))  ;; Return chef's cuisine specialties
        ERR-PROFILE-NOT-FOUND  ;; Return error if profile doesn't exist
    )
)

;; Read-only function to retrieve only a chef's signature dishes
(define-read-only (retrieve-signature-dishes (chef-address principal))
    (match (map-get? chef-profiles chef-address)
        profile (ok (get signature-dishes profile))  ;; Return chef's signature dishes
        ERR-PROFILE-NOT-FOUND  ;; Return error if profile doesn't exist
    )
)

;; Read-only function to retrieve only a chef's recipe collection
(define-read-only (retrieve-recipe-collection (chef-address principal))
    (match (map-get? chef-profiles chef-address)
        profile (ok (get recipe-collection profile))  ;; Return chef's recipe collection
        ERR-PROFILE-NOT-FOUND  ;; Return error if profile doesn't exist
    )
)
