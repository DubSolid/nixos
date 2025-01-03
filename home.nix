{ config, pkgs, lib, ... }:
	
	# gruvbox-plus import
  let
    gruvboxPlus = import ./apps/gruvbox-plus.nix { inherit pkgs; };
  in

	# nix-colors import
  let
    nix-colors = import <nix-colors> { };
  in 

	# nixvim import
  let
    nixvim = import (builtins.fetchGit {
      url = "https://github.com/nix-community/nixvim";
      ref = "nixos-23.11";
    });
  in

{
  # Imports
  imports = [
    ./apps/zsh.nix
    ./apps/lf.nix
    ./apps/waybar.nix
    nix-colors.homeManagerModules.default
    nixvim.homeManagerModules.nixvim
  ];

	# global colorscheme
  colorScheme = nix-colors.colorSchemes.tomorrow-night;

	# program settings
  programs = {
		
		# kitty settings
    kitty = {
      enable = true;
      settings = {
        foreground = "#${config.colorScheme.palette.base05}";
        background = "#${config.colorScheme.palette.base00}";
				background_opacity = "0.9";
				font_family = "SauceCodePro Nerd Font";
      };
    };

		# nixvim settings
    nixvim = {
      enable = true;
			vimAlias = true;
			extraPlugins = [ pkgs.vimPlugins.nvim-base16];
			colorscheme = "base16-tomorrow-night";
      #colorschemes.edge-dark.enable = true;
			
		
			# plugins
      plugins.bufferline.enable = true;
			plugins.lightline.enable = true;
			plugins.nvim-tree.enable = true;
			plugins.treesitter.enable = true;
			plugins.telescope.enable = true;
			plugins.telescope.extensions.fzf-native.enable = true;
			plugins.luasnip.enable = true;
			plugins.nvim-autopairs.enable = true;

			# lsp settings
			plugins.lsp = {
				enable = true;
				capabilities = ''
      		capabilities.textDocument.completion.completionItem = {
        		documentationFormat = { "markdown", "plaintext" },
        		snippetSupport = true,
        		preselectSupport = true,
        		insertReplaceSupport = true,
        		labelDetailsSupport = true,
        		deprecatedSupport = true,
        		commitCharactersSupport = true,
        		tagSupport = { valueSet = { 1 } },
        		resolveSupport = {
        		properties = {
          		"documentation",
          		"detail",
          		"additionalTextEdits",
          		},
        		},
      		}
    		'';
				servers = {
					gopls.enable = true;
					pyright.enable = true;
					nixd.enable = true;
					jsonls.enable = true;
				};
			};
		
			plugins = {
    		cmp-buffer = { enable = true; };
    		cmp-nvim-lsp = { enable = true; };
    		cmp-path = { enable = true; };
    		cmp_luasnip = { enable = true; };
			};

			plugins.copilot-vim.enable = true;

			plugins.nvim-cmp = {
				enable = true;
			    sources = [
        		{ name = "nvim_lsp"; }
        		{ name = "luasnip"; }
        		{ name = "buffer"; }
        		{ name = "path"; }
        		{ name = "nvim_lua"; }
      		];

			    formatting = {
        		fields = [ "abbr" "kind" "menu" ];
        		format =
          		# lua
          		''
            		function(_, item)
              		local icons = {
                		Namespace = "󰌗",
                		Text = "󰉿",
                		Method = "󰆧",
                		Function = "󰆧",
                		Constructor = "",
                		Field = "󰜢",
                		Variable = "󰀫",
                		Class = "󰠱",
                		Interface = "",
                		Module = "",
                		Property = "󰜢",
                		Unit = "󰑭",
                		Value = "󰎠",
                		Enum = "",
                		Keyword = "󰌋",
                		Snippet = "",
										Color = "󰏘",
										File = "󰈚",
										Reference = "󰈇",
										Folder = "󰉋",
										EnumMember = "",
										Constant = "󰏿",
										Struct = "󰙅",
										Event = "",
										Operator = "󰆕",
										TypeParameter = "󰊄",
										Table = "",
										Object = "󰅩",
										Tag = "",
										Array = "[]",
										Boolean = "",
										Number = "",
										Null = "󰟢",
										String = "󰉿",
										Calendar = "",
										Watch = "󰥔",
										Package = "",
										Copilot = "",
										Codeium = "",
										TabNine = "",
              		}

              		local icon = icons[item.kind] or ""
              		item.kind = string.format("%s %s", icon, item.kind or "")
              		return item
									end
									'';
					};

					snippet = { expand = "luasnip"; };

					completion = { completeopt = "menu,menuone,noselect"; };

					window = {
						completion = {
							winhighlight =
								"NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder";
							scrollbar = true;
							sidePadding = 2;
							border = "rounded";
						};

						documentation = {
							border = "rounded";
							winhighlight =
								"NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder";
						};
      		};

					mapping = {
        		"<C-Down>" = "cmp.mapping.select_next_item()";
        		"<C-Up>" = "cmp.mapping.select_prev_item()";
						"<CR>" = "cmp.mapping.confirm({ select = true })";
						"<C-CR>" = {
							action = ''
								function(fallback)
								if cmp.visible() then
									cmp.select_next_item()
										elseif luasnip.expandable() then
										luasnip.expand()
										elseif luasnip.expand_or_jumpable() then
										luasnip.expand_or_jump()
										elseif check_backspace() then
										fallback()
								else
									fallback()
										end
										end
										'';
							modes = [ "i" "s" ];
						};
					};
				};

			# div options
      options = {
	  		number = true;
				relativenumber = true;
        tabstop = 2;
        shiftwidth = 2;
        expandtab = false;
      };
			
			# key remaps
			globals.mapleader = " ";

			keymaps = [
      	{
        	key = "<C-f>";
        	options.silent = true;
        	action = "<cmd>:NvimTreeToggle<CR>";
      	}
				{
					key = "<A-w>";
					options.silent = true;
					action = "<cmd>:tabnew<CR>";
				}
				{
					key = "<A-q>";
					options.silent = true;
					action = "<cmd>:-tabnext<CR>";
				}
				{
					key = "<A-e>";
					options.silent = true;
					action = "<cmd>:+tabnext<CR>";
				}
				{
					key = "<C-t>";
					options.silent = true;
					action = "<cmd>:Telescope<CR>";
				}
				{
					key = "<A-t>";
					options.silent = true;
					action = "<cmd>:terminal<CR>";
				}
				{
					key = "<leader>sp";
					options.silent = true;
					action = "<cmd>sp<CR>";
				}
				{
					key = "<leader>vsp";
					options.silent = true;
					action = "<cmd>vsp<CR>";
				}
				{
					key = "<A-h>";
					options.silent = true;
					action = "<cmd>vertical resize +2<CR>";
				}
				{
					key = "<A-l>";
					options.silent = true;
					action = "<cmd>vertical resize -2<CR>";
				}
				{
					key = "<A-j>";
					options.silent = true;
					action = "<cmd>horizontal resize +2<CR>"; 
				}
				{
					key = "<A-k>";
					options.silent = true;
					action = "<cmd>horizontal resize -2<CR>";
				}
    	];
  	};
	};

  # Info
  home.username = "xcom";
  home.homeDirectory = "/home/xcom";

  home.stateVersion = "23.11";

  nixpkgs.config.allowUnfree = true;

  # Packages
  home.packages = with pkgs; [
    btop
    hyprpaper
    nerdfonts
    networkmanagerapplet
    signal-desktop
    discord
    bitwarden
    grim
    swappy
    slurp
    spotify
    playerctl
    go
    unzip
		brightnessctl
		brave
		tmux
		virt-manager
  ];

  # gtk
  gtk = {
    enable = true;
    theme = {
      package = pkgs.gnome.gnome-themes-extra;
      name = "Adwaita-dark";
    };
  };

	programs.fuzzel.settings = {
  	main = {
    terminal = "${pkgs.foot}/bin/foot";
    layer = "overlay";
  };
  colors.background = "#92a8d";
	};


  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
