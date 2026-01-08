I will reorganize your project code to strictly follow the MVVM (`@controller+page+entity`) architecture and modularize reusable components.

### 1. Architectural Refactoring & Standardization
- **Goal**: Clarify the project structure and separate concerns.
- **Action**:
  - Establish a dedicated `lib/widgets/` directory for reusable UI components.
  - Ensure all page-specific controllers are co-located with their pages (Feature-First approach).
  - Ensure global controllers (like `ThemeController`) remain in `lib/controllers/`.
  - Ensure entities remain in `lib/entity/`.

### 2. Modularize Reusable Components (Widgets)
I will extract the following components into independent files in `lib/widgets/` to reduce code duplication and improve readability:

- **`PasswordCard`**: Extracted from `Home.dart`. Represents a single password item in the list.
- **`CustomSearchBar`**: Extracted from `Home.dart`. Encapsulates the text field with search icon and clear button.
- **`TagSelector`**: Extracted from `Home.dart`. The row of "All" / "Common" selection chips.
- **`DetailRow`**: Extracted from `PasswordDetails.dart`. Standardizes the display of label/icon + value rows (Date, Website, Username).
- **`ActionButton`**: Extracted from `PasswordDetails.dart`. The "Update" and "Delete" buttons with their specific styling and gesture logic.

### 3. Implementation Steps
1.  **Create Widget Files**: Create the files in `lib/widgets/` with the extracted code.
2.  **Refactor `Home.dart`**: Replace the inline `_buildSingleCard`, search bar logic, and selection row with the new widgets.
3.  **Refactor `PasswordDetails.dart`**: Replace the repetitive `_build...Details` methods and button logic with `DetailRow` and `ActionButton`.
4.  **Verify Imports**: Ensure all references to controllers and entities are correct after moving code.

This approach aligns with your requested `@controller+page+entity` pattern while significantly cleaning up the "Page" layer by delegating UI logic to reusable "Widgets".
