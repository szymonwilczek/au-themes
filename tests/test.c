/* test.c --- Syntax and token test fixture for au-themes -*- coding: utf-8; mode: c -*- */

/*
 * Copyright (C) 2026  Szymon Wilczek
 *
 * Author: Szymon Wilczek <swilczek.lx@gmail.com>
 * URL: https://github.com/szymonwilczek/au-themes
 *
 * This file is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this file.  If not, see <https://www.gnu.org/licenses/>.
 */

/*
 * Commentary:
 *
 * Visual test fixture and syntax showcase for the au-themes suite.
 * Exercises all font-lock faces, semantic syntax highlighting categories,
 * and enumerates all palette tokens across the three core layers:
 *
 * 1) Canvas & Chrome:
 *    cursor, bg-main, bg-dim, bg-alt, fg-main, fg-dim, fg-alt, fg-var,
 *    bg-active, bg-inactive, border
 *
 * 2) Basic Chromatic Scale:
 *    red, red-warmer, red-cooler, red-faint, green, green-warmer,
 *    green-cooler, green-faint, yellow, yellow-warmer, yellow-cooler,
 *    yellow-faint, blue, blue-warmer, blue-cooler, blue-faint, magenta,
 *    magenta-warmer, magenta-cooler, magenta-faint, cyan, cyan-warmer,
 *    cyan-cooler, cyan-faint
 *
 * 3) Panels, Diffs and Structural Highlights:
 *    bg-red-intense, bg-green-intense, bg-yellow-intense, bg-blue-intense,
 *    bg-magenta-intense, bg-cyan-intense, bg-red-subtle, bg-green-subtle,
 *    bg-yellow-subtle, bg-blue-subtle, bg-magenta-subtle, bg-cyan-subtle,
 *    bg-added, bg-added-faint, bg-added-refine, fg-added, bg-changed,
 *    bg-changed-faint, bg-changed-refine, fg-changed, bg-removed,
 *    bg-removed-faint, bg-removed-refine, fg-removed, bg-mode-line-active,
 *    fg-mode-line-active, bg-completion, bg-popup, bg-hover,
 *    bg-hover-secondary, bg-hl-line, bg-paren-match, bg-err, bg-warning,
 *    bg-info, bg-region, fg-line-number-inactive
 */

#ifndef AU_TEST_C
#define AU_TEST_C

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Preprocessor Directives, Macro Aliases and Constants */
/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

#define AU_THEME_TOKEN_COUNT       72U
#define LOTA_PCR_COUNT             24U
#define BUFFER_CAPACITY_BYTES      1024ULL
#define OKLAB_LIGHTNESS_REF        0.8776f
#define MACRO_STRING_EXPAND(x)     #x
#define STRINGIFY(x)               MACRO_STRING_EXPAND(x)
#define CLAMP(val, min, max)       ((val) < (min) ? (min) : ((val) > (max) ? (max) : (val)))

#if defined(__GNUC__) || defined(__clang__)
#  define AU_INLINE                static inline __attribute__((always_inline))
#  define AU_UNUSED                __attribute__((unused))
#else
#  define AU_INLINE                static inline
#  define AU_UNUSED
#endif

/* Enumerations and Composite Types */
/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

typedef enum au_severity_level {
    AU_SEV_INFO    = 0,  /* Informational state */
    AU_SEV_WARNING = 1,  /* Potential warning state */
    AU_SEV_ERROR   = 2,  /* Critical error condition */
    AU_SEV_FATAL   = 3   /* Fatal exception / assertion */
} au_severity_level_t;

typedef enum au_category_layer {
    AU_LAYER_CANVAS_CHROME = 1,
    AU_LAYER_CHROMATIC     = 2,
    AU_LAYER_PANELS_DIFFS  = 3
} au_category_layer_t;

struct au_color_coordinate {
    double l_star;       /* Oklab L: perceived lightness [0.0..1.0] */
    double a_star;       /* Green-red chrominance */
    double b_star;       /* Blue-yellow chrominance */
    uint32_t srgb_hex;   /* Packed 24-bit sRGB value */
};

typedef struct au_palette_token {
    size_t index;
    const char *token_name;
    const char *hex_code;
    au_category_layer_t layer;
    au_severity_level_t severity;
    struct au_color_coordinate coord;
} au_palette_token_t;

/* Canonical Token Registry for Theme Testing */
/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

static const au_palette_token_t AU_MASTER_TOKENS[AU_THEME_TOKEN_COUNT] = {
    /* Canvas & Chrome */
    {  0, "cursor",                  "#8c5a08", AU_LAYER_CANVAS_CHROME, AU_SEV_INFO,    {0.45,  0.03,  0.08, 0x8c5a08} },
    {  1, "bg-main",                 "#ded8cc", AU_LAYER_CANVAS_CHROME, AU_SEV_INFO,    {0.87, -0.01,  0.02, 0xded8cc} },
    {  2, "bg-dim",                  "#d2cbbe", AU_LAYER_CANVAS_CHROME, AU_SEV_INFO,    {0.82, -0.01,  0.02, 0xd2cbbe} },
    {  3, "bg-alt",                  "#c6bfb0", AU_LAYER_CANVAS_CHROME, AU_SEV_INFO,    {0.77, -0.01,  0.02, 0xc6bfb0} },
    {  4, "fg-main",                 "#2b2720", AU_LAYER_CANVAS_CHROME, AU_SEV_INFO,    {0.20,  0.01,  0.02, 0x2b2720} },
    {  5, "fg-dim",                  "#625d54", AU_LAYER_CANVAS_CHROME, AU_SEV_INFO,    {0.43,  0.00,  0.02, 0x625d54} },
    {  6, "fg-alt",                  "#605644", AU_LAYER_CANVAS_CHROME, AU_SEV_INFO,    {0.40,  0.01,  0.04, 0x605644} },
    {  7, "fg-var",                  "#2b2720", AU_LAYER_CANVAS_CHROME, AU_SEV_INFO,    {0.20,  0.01,  0.02, 0x2b2720} },
    {  8, "bg-active",               "#c8c0b2", AU_LAYER_CANVAS_CHROME, AU_SEV_INFO,    {0.78, -0.01,  0.02, 0xc8c0b2} },
    {  9, "bg-inactive",             "#d2cbbe", AU_LAYER_CANVAS_CHROME, AU_SEV_INFO,    {0.82, -0.01,  0.02, 0xd2cbbe} },
    { 10, "border",                  "#a49c8c", AU_LAYER_CANVAS_CHROME, AU_SEV_INFO,    {0.65, -0.01,  0.02, 0xa49c8c} },

    /* Basic Chromatic Scale */
    { 11, "red",                     "#a54b32", AU_LAYER_CHROMATIC,     AU_SEV_ERROR,   {0.48,  0.10,  0.08, 0xa54b32} },
    { 12, "red-warmer",              "#8a3a22", AU_LAYER_CHROMATIC,     AU_SEV_INFO,    {0.40,  0.09,  0.07, 0x8a3a22} },
    { 13, "red-cooler",              "#9e422c", AU_LAYER_CHROMATIC,     AU_SEV_INFO,    {0.45,  0.10,  0.07, 0x9e422c} },
    { 14, "red-faint",               "#544e45", AU_LAYER_CHROMATIC,     AU_SEV_INFO,    {0.36,  0.01,  0.02, 0x544e45} },
    { 15, "green",                   "#396632", AU_LAYER_CHROMATIC,     AU_SEV_INFO,    {0.45, -0.08,  0.07, 0x396632} },
    { 16, "green-warmer",            "#724818", AU_LAYER_CHROMATIC,     AU_SEV_INFO,    {0.41,  0.04,  0.08, 0x724818} },
    { 17, "green-cooler",            "#543500", AU_LAYER_CHROMATIC,     AU_SEV_INFO,    {0.32,  0.03,  0.07, 0x543500} },
    { 18, "green-faint",             "#625d54", AU_LAYER_CHROMATIC,     AU_SEV_INFO,    {0.43,  0.00,  0.02, 0x625d54} },
    { 19, "yellow",                  "#543500", AU_LAYER_CHROMATIC,     AU_SEV_INFO,    {0.32,  0.03,  0.07, 0x543500} },
    { 20, "yellow-warmer",           "#675b13", AU_LAYER_CHROMATIC,     AU_SEV_WARNING, {0.43, -0.01,  0.09, 0x675b13} },
    { 21, "yellow-cooler",           "#674759", AU_LAYER_CHROMATIC,     AU_SEV_INFO,    {0.39,  0.05, -0.02, 0x674759} },
    { 22, "yellow-faint",            "#70685a", AU_LAYER_CHROMATIC,     AU_SEV_INFO,    {0.47,  0.01,  0.04, 0x70685a} },
    { 23, "blue",                    "#30385e", AU_LAYER_CHROMATIC,     AU_SEV_INFO,    {0.31,  0.02, -0.08, 0x30385e} },
    { 24, "blue-warmer",             "#584a7a", AU_LAYER_CHROMATIC,     AU_SEV_INFO,    {0.38,  0.05, -0.07, 0x584a7a} },
    { 25, "blue-cooler",             "#585248", AU_LAYER_CHROMATIC,     AU_SEV_INFO,    {0.38,  0.01,  0.02, 0x585248} },
    { 26, "blue-faint",              "#2c6957", AU_LAYER_CHROMATIC,     AU_SEV_INFO,    {0.43, -0.06,  0.02, 0x2c6957} },
    { 27, "magenta",                 "#30385e", AU_LAYER_CHROMATIC,     AU_SEV_INFO,    {0.31,  0.02, -0.08, 0x30385e} },
    { 28, "magenta-warmer",          "#8e402a", AU_LAYER_CHROMATIC,     AU_SEV_INFO,    {0.42,  0.09,  0.08, 0x8e402a} },
    { 29, "magenta-cooler",          "#743a18", AU_LAYER_CHROMATIC,     AU_SEV_INFO,    {0.37,  0.07,  0.07, 0x743a18} },
    { 30, "magenta-faint",           "#625d54", AU_LAYER_CHROMATIC,     AU_SEV_INFO,    {0.43,  0.00,  0.02, 0x625d54} },
    { 31, "cyan",                    "#4a3400", AU_LAYER_CHROMATIC,     AU_SEV_INFO,    {0.29,  0.03,  0.07, 0x4a3400} },
    { 32, "cyan-warmer",             "#674759", AU_LAYER_CHROMATIC,     AU_SEV_INFO,    {0.39,  0.05, -0.02, 0x674759} },
    { 33, "cyan-cooler",             "#585248", AU_LAYER_CHROMATIC,     AU_SEV_INFO,    {0.38,  0.01,  0.02, 0x585248} },
    { 34, "cyan-faint",              "#665f54", AU_LAYER_CHROMATIC,     AU_SEV_INFO,    {0.43,  0.01,  0.03, 0x665f54} },

    /* Panels, Diffs and Structural Highlights */
    { 35, "bg-red-intense",          "#e89e8e", AU_LAYER_PANELS_DIFFS,  AU_SEV_FATAL,   {0.77,  0.09,  0.05, 0xe89e8e} },
    { 36, "bg-green-intense",        "#a2cc94", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.80, -0.07,  0.06, 0xa2cc94} },
    { 37, "bg-yellow-intense",       "#deb658", AU_LAYER_PANELS_DIFFS,  AU_SEV_WARNING, {0.79,  0.01,  0.12, 0xdeb658} },
    { 38, "bg-blue-intense",         "#caa4cc", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.77,  0.06, -0.04, 0xcaa4cc} },
    { 39, "bg-magenta-intense",      "#d0a6bc", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.77,  0.06, -0.01, 0xd0a6bc} },
    { 40, "bg-cyan-intense",         "#94caa0", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.79, -0.07,  0.04, 0x94caa0} },
    { 41, "bg-red-subtle",           "#e6c4ba", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.85,  0.04,  0.02, 0xe6c4ba} },
    { 42, "bg-green-subtle",         "#d2e4ca", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.90, -0.03,  0.03, 0xd2e4ca} },
    { 43, "bg-yellow-subtle",        "#ece0b8", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.91, -0.01,  0.05, 0xece0b8} },
    { 44, "bg-blue-subtle",          "#ded2de", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.88,  0.02, -0.01, 0xded2de} },
    { 45, "bg-magenta-subtle",       "#e2ced8", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.87,  0.03, -0.01, 0xe2ced8} },
    { 46, "bg-cyan-subtle",          "#c6d8c0", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.86, -0.03,  0.03, 0xc6d8c0} },
    { 47, "bg-added",                "#c8e4c4", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.87, -0.06,  0.05, 0xc8e4c4} },
    { 48, "bg-added-faint",          "#daf0d8", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.92, -0.04,  0.03, 0xdaf0d8} },
    { 49, "bg-added-refine",         "#b6dbb0", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.83, -0.07,  0.06, 0xb6dbb0} },
    { 50, "fg-added",                "#185422", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.38, -0.09,  0.07, 0x185422} },
    { 51, "bg-changed",              "#ede0b0", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.88, -0.01,  0.08, 0xede0b0} },
    { 52, "bg-changed-faint",        "#f6edd0", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.92, -0.01,  0.05, 0xf6edd0} },
    { 53, "bg-changed-refine",       "#e2d098", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.83, -0.01,  0.10, 0xe2d098} },
    { 54, "fg-changed",              "#5c4208", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.37,  0.02,  0.09, 0x5c4208} },
    { 55, "bg-removed",              "#eecac4", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.83,  0.05,  0.03, 0xeecac4} },
    { 56, "bg-removed-faint",        "#f8e2de", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.90,  0.03,  0.02, 0xf8e2de} },
    { 57, "bg-removed-refine",       "#e2b5ad", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.77,  0.06,  0.04, 0xe2b5ad} },
    { 58, "fg-removed",              "#78201a", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.35,  0.11,  0.06, 0x78201a} },
    { 59, "bg-mode-line-active",     "#c8c0b2", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.78, -0.01,  0.02, 0xc8c0b2} },
    { 60, "fg-mode-line-active",     "#1f1c16", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.15,  0.01,  0.01, 0x1f1c16} },
    { 61, "bg-completion",           "#cbcdb8", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.81, -0.03,  0.04, 0xcbcdb8} },
    { 62, "bg-popup",                "#e6e0d4", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.89, -0.01,  0.02, 0xe6e0d4} },
    { 63, "bg-hover",                "#ccc6b8", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.80, -0.01,  0.02, 0xccc6b8} },
    { 64, "bg-hover-secondary",      "#d2ccc0", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.82, -0.01,  0.02, 0xd2ccc0} },
    { 65, "bg-hl-line",              "#d5cfc2", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.83, -0.01,  0.02, 0xd5cfc2} },
    { 66, "bg-paren-match",          "#d4ba8a", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.78,  0.01,  0.09, 0xd4ba8a} },
    { 67, "bg-err",                  "#ebd0c8", AU_LAYER_PANELS_DIFFS,  AU_SEV_ERROR,   {0.85,  0.04,  0.03, 0xebd0c8} },
    { 68, "bg-warning",              "#ebddb0", AU_LAYER_PANELS_DIFFS,  AU_SEV_WARNING, {0.87, -0.01,  0.08, 0xebddb0} },
    { 69, "bg-info",                 "#dcd4b8", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.84, -0.02,  0.05, 0xdcd4b8} },
    { 70, "bg-region",               "#d8be78", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.79,  0.00,  0.12, 0xd8be78} },
    { 71, "fg-line-number-inactive", "#867e70", AU_LAYER_PANELS_DIFFS,  AU_SEV_INFO,    {0.60,  0.00,  0.02, 0x867e70} }
};

/* Syntax Showcase and Logic Verification Functions */
/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

/**
 * @brief Evaluates perceptual color distance metrics for theme gates.
 *
 * @param token    Pointer to palette token descriptor.
 * @param ambient  Lightness reference constant.
 * @return true    if chromaticity respects Bouma crowding boundaries, false otherwise.
 */
AU_INLINE bool au_evaluate_perceptual_gate(const au_palette_token_t *token, double ambient) {
    if (token == NULL) {
        /* Null pointer guard */
        return false;
    }

    /* Local variable definitions */
    double delta_lightness = token->coord.l_star - ambient;
    bool is_contrast_acceptable = false;

    /* Binary arithmetic, ternary operators, and logical conjunctions */
    if ((delta_lightness >= -0.75f && delta_lightness <= 0.75f) || token->severity == AU_SEV_INFO) {
        is_contrast_acceptable = true;
    }

    /* Bitwise manipulation demo */
    uint32_t packed_rgb = token->coord.srgb_hex;
    uint8_t r = (uint8_t)((packed_rgb >> 16) & 0xFFU);
    uint8_t g = (uint8_t)((packed_rgb >> 8)  & 0xFFU);
    uint8_t b = (uint8_t)(packed_rgb         & 0xFFU);

    AU_UNUSED uint32_t grayscale_luma = (uint32_t)(0.2126 * r + 0.7152 * g + 0.0722 * b);

    return is_contrast_acceptable;
}

/**
 * @brief Main test runner dispatching diagnostic sweeps.
 */
int main(int argc, char **argv) {
    (void)argv;
    printf("=== Au-Themes Diagnostic Syntax Showcase (PID: %d) ===\n", (int)argc);

    size_t passed_count = 0;
    size_t failed_count = 0;
    char buffer[BUFFER_CAPACITY_BYTES];

    /* Character literals, format strings, and escape sequences */
    const char escape_newline = '\n';
    const char *status_format = "[%02zu/72] Token '%-24s' [%s] -> %s%c";

    for (size_t i = 0; i < AU_THEME_TOKEN_COUNT; ++i) {
        const au_palette_token_t *tok = &AU_MASTER_TOKENS[i];

        bool passed = au_evaluate_perceptual_gate(tok, OKLAB_LIGHTNESS_REF);
        if (passed) {
            passed_count++;
        } else {
            failed_count++;
        }

        snprintf(buffer, sizeof(buffer), status_format,
                 tok->index + 1,
                 tok->token_name,
                 tok->hex_code,
                 passed ? "PASS" : "FAIL",
                 escape_newline);

        fputs(buffer, stdout);
    }

    /* Single-line comment: verify structural bracket balancing { [ ( ) ] } */
    // Note: Diff simulation block for testing contextual font-lock:
    // --- a/lisp/old_syntax.el
    // +++ b/lisp/new_syntax.el
    // @@ -10,3 +10,4 @@
    // - (setq obsolete-flag t)
    // + (setq modern-flag t)

    /* Multi-line comment: check Flymake / annotation face triggers */
    /*
     * TODO: Verify M/P pathway balancing across parvocellular gates.
     * FIXME: Ensure no isoluminant edge-jitter across consecutive tokens.
     * NOTE: All tokens completely calibrated for neurodivergent sensory profiles.
     */

    printf("\nSummary: %zu tokens evaluated. Passed: %zu, Failed: %zu\n",
           (size_t)AU_THEME_TOKEN_COUNT, passed_count, failed_count);

    return (failed_count == 0) ? EXIT_SUCCESS : EXIT_FAILURE;
}

#endif /* AU_TEST_C */
