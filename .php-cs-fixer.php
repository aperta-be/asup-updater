<?php

$finder = PhpCsFixer\Finder::create()
    ->in([
        __DIR__ . '/scripts/app/php',
    ])
    ->exclude([
        'vendor',
        'tests',
    ]);

$config = new PhpCsFixer\Config();
return $config
    ->setRiskyAllowed(true)
    ->setRules([
        '@PSR12' => true,
        '@PHP74Migration' => true,
        '@PHP74Migration:risky' => true,
        '@PHPUnit84Migration:risky' => true,
        
        // Array notation
        'array_syntax' => ['syntax' => 'short'],
        'no_multiline_whitespace_around_double_arrow' => true,
        'no_trailing_comma_in_singleline_array' => true,
        'trim_array_spaces' => true,
        'whitespace_after_comma_in_array' => true,
        
        // Basic
        'encoding' => true,
        'single_quote' => true,
        'no_trailing_comma_in_singleline' => true,
        'no_unused_imports' => true,
        
        // Class notation
        'class_attributes_separation' => true,
        'no_blank_lines_after_class_opening' => true,
        'no_null_property_initialization' => true,
        'self_accessor' => true,
        
        // Control structures
        'no_unneeded_control_parentheses' => true,
        'no_unneeded_curly_braces' => true,
        'no_useless_else' => true,
        
        // Function notation
        'function_typehint_space' => true,
        'lambda_not_used_import' => true,
        'nullable_type_declaration_for_default_null_value' => true,
        
        // Import
        'fully_qualified_strict_types' => true,
        'global_namespace_import' => [
            'import_classes' => true,
            'import_constants' => false,
            'import_functions' => false,
        ],
        'no_leading_import_slash' => true,
        'ordered_imports' => ['sort_algorithm' => 'alpha'],
        
        // Language constructs
        'combine_consecutive_issets' => true,
        'combine_consecutive_unsets' => true,
        'declare_strict_types' => true,
        
        // Namespace notation
        'no_leading_namespace_whitespace' => true,
        
        // Operator
        'binary_operator_spaces' => true,
        'concat_space' => ['spacing' => 'one'],
        'increment_style' => ['style' => 'post'],
        'object_operator_without_whitespace' => true,
        'standardize_not_equals' => true,
        'ternary_operator_spaces' => true,
        'ternary_to_null_coalescing' => true,
        'unary_operator_spaces' => true,
        
        // PHP Tag
        'linebreak_after_opening_tag' => true,
        
        // PHPDoc
        'align_multiline_comment' => true,
        'no_blank_lines_after_phpdoc' => true,
        'no_empty_phpdoc' => true,
        'phpdoc_add_missing_param_annotation' => true,
        'phpdoc_indent' => true,
        'phpdoc_no_empty_return' => true,
        'phpdoc_no_package' => true,
        'phpdoc_order' => true,
        'phpdoc_scalar' => true,
        'phpdoc_separation' => true,
        'phpdoc_single_line_var_spacing' => true,
        'phpdoc_trim' => true,
        'phpdoc_types' => true,
        'phpdoc_var_without_name' => true,
        
        // Return notation
        'no_useless_return' => true,
        'return_type_declaration' => true,
        
        // Semicolon
        'multiline_whitespace_before_semicolons' => true,
        'no_empty_statement' => true,
        'no_singleline_whitespace_before_semicolons' => true,
        'space_after_semicolon' => true,
        
        // String notation
        'explicit_string_variable' => true,
        'simple_to_complex_string_variable' => true,
        
        // Whitespace
        'array_indentation' => true,
        'method_chaining_indentation' => true,
        'no_extra_blank_lines' => [
            'tokens' => [
                'break',
                'case',
                'continue',
                'curly_brace_block',
                'default',
                'extra',
                'parenthesis_brace_block',
                'return',
                'square_brace_block',
                'switch',
                'throw',
                'use',
            ],
        ],
        'no_spaces_around_offset' => true,
    ])
    ->setFinder($finder);