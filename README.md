# Culinary Profile Manager

A blockchain-based smart contract for managing culinary profiles on-chain. This contract allows chefs to create, modify, and retrieve detailed profiles that include their name, experience level, specialties, signature dishes, and recipe collections.

## Features

- **Create Culinary Profile**: Chefs can create a unique culinary profile with a name, experience level, cuisine specialties, signature dishes, and a recipe collection.
- **Modify Culinary Profile**: Chefs can update their profiles to reflect their latest experiences, dishes, and specialties.
- **Retrieve Profile Information**: Users can retrieve a chef's full profile, or query specific aspects like signature dishes, cuisine specialties, or recipes.
- **Validation & Error Handling**: Includes comprehensive validation for input values, ensuring profiles are complete and correct before storing them on the blockchain.

## Smart Contract Functions

- `create-chef-profile`: Create a new culinary profile with validation.
- `modify-chef-profile`: Modify an existing culinary profile, with validation checks.
- `retrieve-chef-profile`: Retrieve the complete culinary profile of a chef.
- `retrieve-cuisine-specialties`: Retrieve a chef's list of cuisine specialties.
- `retrieve-signature-dishes`: Retrieve a chef's list of signature dishes.
- `retrieve-recipe-collection`: Retrieve a chef's list of recipes.

## Example Usage

### 1. Create a Chef Profile

```clarity
(create-chef-profile "Chef John Doe" 5 ["Italian" "French"] ["Lasagna" "Ratatouille"] ["Pasta Carbonara" "Beef Wellington"])
```

### 2. Modify Chef Profile

```clarity
(modify-chef-profile "Chef John Doe" 6 ["Italian" "French" "Mexican"] ["Lasagna" "Tacos"] ["Pasta Carbonara" "Beef Wellington" "Churros"])
```

### 3. Retrieve Chef Profile

```clarity
(retrieve-chef-profile 'principal_address')
```

### 4. Retrieve Cuisine Specialties

```clarity
(retrieve-cuisine-specialties 'principal_address')
```

### 5. Retrieve Signature Dishes

```clarity
(retrieve-signature-dishes 'principal_address')
```

## Error Codes

- `ERR-PROFILE-NOT-FOUND`: Profile not found for the given chef address.
- `ERR-PROFILE-EXISTS`: A profile already exists for the given chef address.
- `ERR-INVALID-EXPERIENCE`: Invalid experience level. It should be between 2 and 75 years.
- `ERR-INVALID-CHEF-NAME`: Invalid chef name format.
- `ERR-INVALID-DISH`: Invalid dish entry.
- `ERR-INVALID-CUISINE`: Invalid cuisine specialty.
- `ERR-INVALID-RECIPE`: Invalid recipe entry.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
