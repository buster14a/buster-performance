# Direct lookahead ownership and output-lane bounds

The candidate at 20332af513764ae677248bdd32d348120141f81f is based on b86eadcbd3d6c5cdf687f6b67b0281df2ac34034. It includes direct lookahead ownership and bounds the ordinary lexer output loop using both start and end masks. Its carried block-comment handling remains the original implementation on b86eadcbd. The three-change comparison is a1609b1e923184f18c30ff98275f54f99339312e.

The exact 9700X Release candidate executable is 52984f3b6af9ce54c9a6bd1695fdb6ab6093ed4e07964d0a4c5b775a8edab244. Its pristine counterpart is 06e22d737854b1308c2d2ac408b01574348e08ca07823114b993aaf271b563d3.

All four repository lexer-mode suites, the refinement suite and the full default preprocessor suite passed on this exact Release. The existing lexer suites cover 35,200 guarded page-edge inputs per mode and separator setting, and 250,000 random inputs per mode and setting. The preprocessor suite covers 1,500 random C17 and 1,500 random C23 cases. The full ordinary CLI campaign agreed on every exit status, diagnostic and output byte across 196 invocations, including 159 ELF outputs, 13 expected rejections, 2,587,151 preprocessor-output bytes and 26,027 diagnostic bytes.

A separate exact token-column comparison covered 95 files and 165 modes. The complete raw corpus covered 2,688 file and language-mode combinations and 10,054,953 tokens, compared both to the original vector stream and to its scalar oracle. The preprocessor and include comparison matched 58,272,230 transcript bytes across 90 units, including 1,480,145 output tokens and 193,797 macro expansion records. The driver and source transcript harnesses are the same as in the earlier source qualification under adf1a5714 and 220f299c6.
