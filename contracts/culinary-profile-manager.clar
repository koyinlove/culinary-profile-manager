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

