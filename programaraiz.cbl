      $set sourceformat"free"

      *>Divisão de identificação do programa
       Identification Division.
       Program-id. "programaraiz".
       Author. "Jéssica C.Del'agnolo".
       Installation. "PC".
       Date-written. 28/07/2020.
       Date-compiled. 28/07/2020.



      *>Divisão para configuração do ambiente
       Environment Division.
       Configuration Section.
           special-names. decimal-point is comma.

      *>----Declaração dos recursos externos
       Input-output Section.
       File-control.
       I-O-Control.


      *>Declaração de variáveis
       Data Division.

      *>----Variaveis de arquivos
       File Section.


      *>----Variaveis de trabalho
       Working-storage Section.


       01 ws-msg-erro.
          05 ws-msg-erro-ofsset                    pic 9(04).
          05 filler                                pic x(01) value "-".
          05 ws-msg-erro-cod                       pic 9(02).
          05 filler                                pic x(01) value space.
          05 ws-msg-erro-text                      pic x(42).

       01  ws-cadastro.
           05  ws-cod_aluno                        pic 9(05).
           05  ws-nome_aluno                       pic x(35).
           05  ws-data_nasc.
               10  ws-dia                          pic 9(02).
               10  ws-mes                          pic 9(02).
               10  ws-ano                          pic 9(04).
           05  ws-endereco.
               10  ws-cep                          pic x(09).
               10  ws-rua                          pic x(25).
               10  ws-n_casa                       pic 9(05).
               10  ws-bairro                       pic x(20).
               10  ws-cidade                       pic x(20).
               10  ws-uf                           pic x(02).
           05  ws-nome_mae                         pic x(35).
           05  ws-nome_pai                         pic x(35).
           05  ws-fone_pais                        pic x(15).
           05  ws-notas-todas.
               10  ws-notas occurs 4.
                   15 ws-nota                      pic 99,99.
           05  ws-media                            pic 99,99.
           05  ws-situacao                         pic x(09).

       77  ws-entra-opcao                          pic 9(01).

       01  ws-controle.
           05  ws-edita-cadastro                   pic x(01).
           05  ws-deleta-cadastro                  pic x(01).
           05  ws-ant-cadastro                     pic x(01).
           05  ws-prox-cadastro                    pic x(01).
           05  ws-confirmar                        pic x(01).

       77  ws-sair                                 pic x(01).
       77  ws-voltar                               pic x(01).
       77  ws-menu                                 pic 9(01).
       77  ws-funcao                               pic x(02).
       77  ws-msg                                  pic x(50).
       77  ws-next-prev                            pic x(02).


      *>----Variaveis para comunicação entre programas
       Linkage Section.

      *>----Declaração de tela
       Screen Section.

       01  sc-tela-menu.
      *>                                0    1    1    2    2    3    3    4    4    5    5    6    6    7    7    8
      *>                                5    0    5    0    5    0    5    0    5    0    5    0    5    0    5    0
      *>                            ----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
           05 blank screen.
           05 line 03 col 01 value "                                                                     [ ]Sair     ".
           05 line 04 col 01 value "                                                                                 ".
           05 line 05 col 01 value "         >  MENU PRINCIPAL  <                                                    ".
           05 line 06 col 01 value "        [1] Cadastro de Aluno                                                    ".
           05 line 07 col 01 value "        [2] Cadastrar Notas                                                      ".
           05 line 08 col 01 value "        [3] Consultar Cadastro                                                   ".
           05 line 09 col 01 value "        [4] Listar Cadastros                                                     ".
           05 line 10 col 01 value "                                                                                 ".
           05 line 11 col 01 value "           Qual a Operacao Desejada?                                             ".
           05 line 22 col 01 value "              [__________________________________________________]               ".



           05 sc-sair-menu             line 03  col 71 pic x(01)
           using ws-sair               foreground-color 12.
           05 sc-entra-opcao           line 11  col 38 pic 9(01)
           using ws-entra-opcao        foreground-color 15.
           05 sc-msg-erro              line 22  col 16 pic x(50)
           from  ws-msg                foreground-color 15.


       01  sc-tela-cad-aluno.
      *>                                0    1    1    2    2    3    3    4    4    5    5    6    6    7    7    8
      *>                                5    0    5    0    5    0    5    0    5    0    5    0    5    0    5    0
      *>                            ----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
           05 blank screen.
           05 line 01 col 01 value "                                                                     [ ]Voltar   ".
           05 line 02 col 01 value "                                Cadastrar Aluno                                  ".
           05 line 03 col 01 value "                                                                                 ".
           05 line 04 col 01 value "     Cod. Aluno:                                                                 ".
           05 line 05 col 01 value "     Aluno:                                       Data Nasc.:   /  /             ".
           05 line 06 col 01 value "     Nome da Mae:                                                                ".
           05 line 07 col 01 value "     Nome do Pai:                                                                ".
           05 line 08 col 01 value "     CEP:            Endereco:                             N:                    ".
           05 line 09 col 01 value "     Bairro:                        Cidade:                        UF:           ".
           05 line 10 col 01 value "     Telefone:                                                                   ".
           05 line 11 col 01 value "                                                                                 ".
           05 line 22 col 01 value "              [__________________________________________________]               ".



           05 sc-sair-cad-aluno        line 01  col 71 pic x(01)
           using ws-voltar             foreground-color 12.

           05 sc-cod-aluno             line 04  col 18 pic 9(05)
           from  ws-cod_aluno          foreground-color 15.

           05 sc-nome-aluno            line 05  col 13 pic x(35)
           using ws-nome_aluno         foreground-color 15.

           05 sc-dia-nasc              line 05  col 63 pic 9(02)
           using ws-dia                foreground-color 15.

           05 sc-mes-nasc              line 05  col 66 pic 9(02)
           using ws-mes                foreground-color 15.

           05 sc-ano-nasc              line 05  col 69 pic 9(04)
           using ws-ano                foreground-color 15.

           05 sc-nome_mae              line 06  col 19 pic x(35)
           using ws-nome_mae           foreground-color 15.

           05 sc-nome_pai              line 07  col 19 pic x(35)
           using ws-nome_pai           foreground-color 15.

           05 sc-cep                   line 08  col 11 pic x(09)
           using ws-cep                foreground-color 15.

           05 sc-rua                   line 08  col 32 pic x(25)
           using ws-rua                foreground-color 15.

           05 sc-n_casa                line 08  col 63 pic 9(05)
           using ws-n_casa             foreground-color 15.

           05 sc-bairro                line 09  col 14 pic x(20)
           using ws-bairro             foreground-color 15.

           05 sc-cidade                line 09  col 45 pic x(20)
           using ws-cidade             foreground-color 15.

           05 sc-uf                    line 09  col 72 pic x(02)
           using ws-uf                 foreground-color 15.

           05 sc-telefone              line 10  col 16 pic x(15)
           using ws-fone_pais          foreground-color 15.

           05 sc-msg-erro              line 22  col 16 pic x(50)
           from  ws-msg                foreground-color 15.

       01  sc-tela-cad-notas.
      *>                                0    1    1    2    2    3    3    4    4    5    5    6    6    7    7    8
      *>                                5    0    5    0    5    0    5    0    5    0    5    0    5    0    5    0
      *>                            ----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
           05 blank screen.
           05 line 01 col 01 value "                                                                     [ ]Voltar   ".
           05 line 04 col 01 value "                                                                                 ".
           05 line 05 col 01 value "                                Cadastrar Notas                                  ".
           05 line 06 col 01 value "     Cod. Aluno:         Nome:                                                   ".
           05 line 07 col 01 value "                                                                                 ".
           05 line 08 col 01 value "     Notas:       Primeira    Segunda    Terceira    Quarta                      ".
           05 line 09 col 01 value "                  [     ]     [     ]    [     ]     [     ]                     ".
           05 line 10 col 01 value "                                                                                 ".
           05 line 22 col 01 value "              [__________________________________________________]               ".




           05 sc-sair-cad-not          line 01  col 71 pic x(01)
           using ws-voltar             foreground-color 12.

           05 sc-cod-aluno             line 06  col 18 pic 9(05)
           using ws-cod_aluno          foreground-color 15.

           05 sc-nome_aluno            line 06  col 32 pic x(35)
           from  ws-nome_aluno         foreground-color 15.

           05 sc-nota_um               line 09  col 20 pic 99,99
           using ws-nota(01)           foreground-color 15.

           05 sc-nota_dois             line 09  col 32 pic 99,99
           using ws-nota(02)           foreground-color 15.

           05 sc-nota_tres             line 09  col 43 pic 99,99
           using ws-nota(03)           foreground-color 15.

           05 sc-nota_quatro           line 09  col 55 pic 99,99
           using ws-nota(04)           foreground-color 15.

           05 sc-msn-cad-not          line 22  col 16 pic x(50)
           from  ws-msg foreground-color 15.

       01  sc-tela-consulta-cad.
      *>                                0    1    1    2    2    3    3    4    4    5    5    6    6    7    7    8
      *>                                5    0    5    0    5    0    5    0    5    0    5    0    5    0    5    0
      *>                            ----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
           05 blank screen.
           05 line 01 col 01 value "                                                                     [ ]Voltar   ".
           05 line 02 col 01 value "                                Consultar Cadastro                               ".
           05 line 03 col 01 value "                                                                                 ".
           05 line 04 col 01 value "     Cod. Aluno:                                                                 ".
           05 line 05 col 01 value "     Aluno:                                       Data Nasc.:   /  /             ".
           05 line 06 col 01 value "     Nome da Mae:                                                                ".
           05 line 07 col 01 value "     Nome do Pai:                                                                ".
           05 line 08 col 01 value "     CEP:            Endereco:                             N:                    ".
           05 line 09 col 01 value "     Bairro:                        Cidade:                        UF:           ".
           05 line 10 col 01 value "     Telefone:                                                                   ".
           05 line 11 col 01 value "                                                                                 ".
           05 line 12 col 01 value "     Notas:       Primeira    Segunda    Terceira    Quarta                      ".
           05 line 13 col 01 value "                  [     ]     [     ]    [     ]     [     ]                     ".
           05 line 14 col 01 value "                                                                                 ".
           05 line 15 col 01 value "     Media:         Situacao:                                                    ".
           05 line 16 col 01 value "                                                                                 ".
           05 line 22 col 01 value "              [__________________________________________________]               ".



           05 sc-sair-cad-aluno        line 01  col 71 pic x(01)
           using ws-voltar             foreground-color 12.

           05 sc-cod-aluno             line 04  col 18 pic 9(05)
           using ws-cod_aluno          foreground-color 15.

           05 sc-nome-aluno            line 05  col 13 pic x(35)
           from  ws-nome_aluno         foreground-color 15.

           05 sc-dia-nasc              line 05  col 63 pic 9(02)
           from  ws-dia                foreground-color 15.

           05 sc-mes-nasc              line 05  col 66 pic 9(02)
           from  ws-mes                foreground-color 15.

           05 sc-ano-nasc              line 05  col 69 pic 9(04)
           from  ws-ano                foreground-color 15.

           05 sc-nome_mae              line 06  col 19 pic x(35)
           from  ws-nome_mae           foreground-color 15.

           05 sc-nome_pai              line 07  col 19 pic x(35)
           from  ws-nome_pai           foreground-color 15.

           05 sc-cep                   line 08  col 11 pic x(09)
           from  ws-cep                foreground-color 15.

           05 sc-rua                   line 08  col 32 pic x(25)
           from  ws-rua                foreground-color 15.

           05 sc-n_casa                line 08  col 63 pic 9(05)
           from  ws-n_casa             foreground-color 15.

           05 sc-bairro                line 09  col 14 pic x(20)
           from  ws-bairro             foreground-color 15.

           05 sc-cidade                line 09  col 45 pic x(20)
           from  ws-cidade             foreground-color 15.

           05 sc-uf                    line 09  col 72 pic x(02)
           from  ws-uf                 foreground-color 15.

           05 sc-telefone              line 10  col 16 pic x(15)
           from  ws-fone_pais          foreground-color 15.

           05 sc-nota_um               line 13  col 20 pic 99,99
           from  ws-nota(01)           foreground-color 15.

           05 sc-nota_dois             line 13  col 32 pic 99,99
           from  ws-nota(02)           foreground-color 15.

           05 sc-nota_tres             line 13  col 43 pic 99,99
           from  ws-nota(03)           foreground-color 15.

           05 sc-nota_quatro           line 13  col 55 pic 99,99
           from  ws-nota(04)           foreground-color 15.

           05 sc-media                 line 15  col 13 pic 99,99
           from  ws-media              foreground-color 15.

           05 sc-situacao              line 15  col 31 pic x(09)
           from  ws-situacao           foreground-color 15.

           05 sc-msg-erro              line 22  col 16 pic x(50)
           from  ws-msg                foreground-color 15.

       01  sc-tela-listar-cad.
      *>                                0    1    1    2    2    3    3    4    4    5    5    6    6    7    7    8
      *>                                5    0    5    0    5    0    5    0    5    0    5    0    5    0    5    0
      *>                            ----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
           05 blank screen.
           05 line 01 col 01 value "                                                                     [ ]Voltar   ".
           05 line 02 col 01 value "                                Consultar Cadastro                               ".
           05 line 03 col 01 value "                                                                                 ".
           05 line 04 col 01 value "     Cod. Aluno:                                                                 ".
           05 line 05 col 01 value "     Aluno:                                       Data Nasc.:   /  /             ".
           05 line 06 col 01 value "     Nome da Mae:                                                                ".
           05 line 07 col 01 value "     Nome do Pai:                                                                ".
           05 line 08 col 01 value "     CEP:            Endereco:                             N:                    ".
           05 line 09 col 01 value "     Bairro:                        Cidade:                        UF:           ".
           05 line 10 col 01 value "     Telefone:                                                                   ".
           05 line 11 col 01 value "                                                                                 ".
           05 line 12 col 01 value "     Notas:       Primeira    Segunda    Terceira    Quarta                      ".
           05 line 13 col 01 value "                  [     ]     [     ]    [     ]     [     ]                     ".
           05 line 14 col 01 value "                                                                                 ".
           05 line 15 col 01 value "     Media:         Situacao:                                                    ".
           05 line 16 col 01 value "                                                                                 ".
           05 line 17 col 01 value "                                                                                 ".
           05 line 18 col 01 value "                  [ ]Editar Cadastro      [ ]Deletar Cadastro                    ".
           05 line 19 col 01 value "                                                                                 ".
           05 line 16 col 01 value "                                                                                 ".
           05 line 20 col 01 value "    [ ]Anterior                                                    [ ]Proximo    ".
           05 line 21 col 01 value "                                                                                 ".
           05 line 22 col 01 value "              [__________________________________________________]               ".



           05 sc-sair-cad-aluno        line 01  col 71 pic x(01)
           using ws-voltar             foreground-color 12.

           05 sc-cod-aluno             line 04  col 18 pic 9(05)
           from  ws-cod_aluno          foreground-color 15.

           05 sc-nome-aluno            line 05  col 13 pic x(35)
           from  ws-nome_aluno         foreground-color 15.

           05 sc-dia-nasc              line 05  col 63 pic 9(02)
           from  ws-dia                foreground-color 15.

           05 sc-mes-nasc              line 05  col 66 pic 9(02)
           from  ws-mes                foreground-color 15.

           05 sc-ano-nasc              line 05  col 69 pic 9(04)
           from  ws-ano                foreground-color 15.

           05 sc-nome_mae              line 06  col 19 pic x(35)
           from  ws-nome_mae           foreground-color 15.

           05 sc-nome_pai              line 07  col 19 pic x(35)
           from  ws-nome_pai           foreground-color 15.

           05 sc-cep                   line 08  col 11 pic x(09)
           from  ws-cep                foreground-color 15.

           05 sc-rua                   line 08  col 32 pic x(25)
           from  ws-rua                foreground-color 15.

           05 sc-n_casa                line 08  col 63 pic 9(05)
           from  ws-n_casa             foreground-color 15.

           05 sc-bairro                line 09  col 14 pic x(20)
           from  ws-bairro             foreground-color 15.

           05 sc-cidade                line 09  col 45 pic x(20)
           from  ws-cidade             foreground-color 15.

           05 sc-uf                    line 09  col 72 pic x(02)
           from  ws-uf                 foreground-color 15.

           05 sc-telefone              line 10  col 16 pic x(15)
           from  ws-fone_pais          foreground-color 15.

           05 sc-nota_um               line 13  col 20 pic 99,99
           from  ws-nota(01)           foreground-color 15.

           05 sc-nota_dois             line 13  col 32 pic 99,99
           from  ws-nota(02)           foreground-color 15.

           05 sc-nota_tres             line 13  col 43 pic 99,99
           from  ws-nota(03)           foreground-color 15.

           05 sc-nota_quatro           line 13  col 55 pic 99,99
           from  ws-nota(04)           foreground-color 15.

           05 sc-media                 line 15  col 13 pic 99,99
           from  ws-media              foreground-color 15.

           05 sc-situacao              line 15  col 31 pic x(09)
           from  ws-situacao           foreground-color 15.

           05 sc-editar-cad            line 18  col 20 pic x(01)
           using ws-edita-cadastro     foreground-color 15.

           05 sc-deletar-cad           line 18  col 44 pic x(01)
           using ws-deleta-cadastro    foreground-color 15.

           05 sc-anterior              line 20  col 06 pic x(01)
           using ws-ant-cadastro       foreground-color 15.

           05 sc-proximo               line 20  col 69 pic x(01)
           using ws-prox-cadastro      foreground-color 15.

           05 sc-msg-erro              line 22  col 16 pic x(50)
           from  ws-msg                foreground-color 15.

       01  sc-tela-alterar-cad.
      *>                                0    1    1    2    2    3    3    4    4    5    5    6    6    7    7    8
      *>                                5    0    5    0    5    0    5    0    5    0    5    0    5    0    5    0
      *>                            ----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
           05 blank screen.
           05 line 01 col 01 value "                                                                     [ ]Voltar   ".
           05 line 02 col 01 value "                                Consultar Cadastro                               ".
           05 line 03 col 01 value "                                                                                 ".
           05 line 04 col 01 value "     Cod. Aluno:                                                                 ".
           05 line 05 col 01 value "     Aluno:                                       Data Nasc.:   /  /             ".
           05 line 06 col 01 value "     Nome da Mae:                                                                ".
           05 line 07 col 01 value "     Nome do Pai:                                                                ".
           05 line 08 col 01 value "     CEP:            Endereco:                             N:                    ".
           05 line 09 col 01 value "     Bairro:                        Cidade:                        UF:           ".
           05 line 10 col 01 value "     Telefone:                                                                   ".
           05 line 11 col 01 value "                                                                                 ".
           05 line 12 col 01 value "     Notas:       Primeira    Segunda    Terceira    Quarta                      ".
           05 line 13 col 01 value "                  [     ]     [     ]    [     ]     [     ]                     ".
           05 line 14 col 01 value "                                                                                 ".
           05 line 15 col 01 value "     Media:         Situacao:                                                    ".
           05 line 16 col 01 value "                                                                                 ".
           05 line 17 col 01 value "                                                                                 ".
           05 line 18 col 01 value "                                 [ ]Confirmar                                    ".
           05 line 19 col 01 value "                                                                                 ".
           05 line 21 col 01 value "                                                                                 ".
           05 line 22 col 01 value "              [__________________________________________________]               ".



           05 sc-sair-cad-aluno        line 01  col 71 pic x(01)
           using ws-voltar             foreground-color 12.

           05 sc-cod-aluno             line 04  col 18 pic 9(05)
           from  ws-cod_aluno          foreground-color 15.

           05 sc-nome-aluno            line 05  col 13 pic x(35)
           from  ws-nome_aluno         foreground-color 15.

           05 sc-dia-nasc              line 05  col 63 pic 9(02)
           from  ws-dia                foreground-color 15.

           05 sc-mes-nasc              line 05  col 66 pic 9(02)
           from  ws-mes                foreground-color 15.

           05 sc-ano-nasc              line 05  col 69 pic 9(04)
           from  ws-ano                foreground-color 15.

           05 sc-nome_mae              line 06  col 19 pic x(35)
           from  ws-nome_mae           foreground-color 15.

           05 sc-nome_pai              line 07  col 19 pic x(35)
           from  ws-nome_pai           foreground-color 15.

           05 sc-cep                   line 08  col 11 pic x(09)
           from  ws-cep                foreground-color 15.

           05 sc-rua                   line 08  col 32 pic x(25)
           using ws-rua                foreground-color 15.

           05 sc-n_casa                line 08  col 63 pic 9(05)
           using ws-n_casa             foreground-color 15.

           05 sc-bairro                line 09  col 14 pic x(20)
           using ws-bairro             foreground-color 15.

           05 sc-cidade                line 09  col 45 pic x(20)
           using ws-cidade             foreground-color 15.

           05 sc-uf                    line 09  col 72 pic x(02)
           using ws-uf                 foreground-color 15.

           05 sc-telefone              line 10  col 16 pic x(15)
           using ws-fone_pais          foreground-color 15.

           05 sc-nota_um               line 13  col 20 pic 99,99
           using ws-nota(01)           foreground-color 15.

           05 sc-nota_dois             line 13  col 32 pic 99,99
           using ws-nota(02)           foreground-color 15.

           05 sc-nota_tres             line 13  col 43 pic 99,99
           using ws-nota(03)           foreground-color 15.

           05 sc-nota_quatro           line 13  col 55 pic 99,99
           using ws-nota(04)           foreground-color 15.

           05 sc-media                 line 15  col 13 pic 99,99
           from  ws-media              foreground-color 15.

           05 sc-situacao              line 15  col 31 pic x(09)
           from  ws-situacao           foreground-color 15.

           05 sc-confirmar             line 18  col 35 pic x(01)
           using ws-confirmar          foreground-color 15.

           05 sc-msg-erro              line 22  col 16 pic x(50)
           from  ws-msg                foreground-color 15.


      *>Declaração do corpo do programa
       Procedure Division.

           perform inicializa.
           perform procedimento.
           perform finaliza.

       inicializa section.

          move spaces to ws-sair
           .
       inicializa-exit.
           exit.

      *>------------------------------------------------------------------------
      *>   Procedimentos principais
      *>------------------------------------------------------------------------
       procedimento section.

           perform until ws-sair = "X"             *> Menu principal
                      or ws-sair = "x"

               move spaces to ws-voltar
               move 0      to ws-entra-opcao

               display sc-tela-menu
               accept  sc-tela-menu

               evaluate ws-entra-opcao
                   when = 1
                       perform cadastro-aluno
                   when = 2
                       perform cadastro-notas
                   when = 3
                       perform consulta-cadastro
                   when = 4
                       perform lista-cadastro
                   when other
                       move "Opcao Invalida!" to ws-msg
               end-evaluate


           .
       procedimento-exit.
           exit.

      *>------------------------------------------------------------------------
      *> Cadastrar aluno
      *>------------------------------------------------------------------------
       cadastro-aluno section.

           perform until ws-voltar = "X"
                      or ws-voltar = "x"


               move zero   to  ws-cod_aluno        *> Inicializa as variaveis de tela
               move spaces to  ws-nome_aluno
               move zero   to  ws-dia
               move zero   to  ws-mes
               move zero   to  ws-ano
               move spaces to  ws-rua
               move zero   to  ws-n_casa
               move spaces to  ws-bairro
               move spaces to  ws-cidade
               move spaces to  ws-uf
               move spaces to  ws-cep
               move spaces to  ws-nome_mae
               move spaces to  ws-nome_pai
               move spaces to  ws-fone_pais
               move zero   to  ws-nota(01)
               move zero   to  ws-nota(02)
               move zero   to  ws-nota(03)
               move zero   to  ws-nota(04)
               move zero   to  ws-media
               move spaces to  ws-situacao

               move "bc"   to  ws-funcao           *> Movendo a função a ser utilizada no programa de processamento (Buscar o código)

               call "processamento" using  ws-cadastro,   *> Chamar o programa para buscar o código
                                           ws-msg-erro,
                                           ws-funcao,
                                           ws-msg

               display sc-tela-cad-aluno
               accept  sc-tela-cad-aluno

               move "ca"   to  ws-funcao           *> Movendo a função a ser utilizada no programa de processamento (Cadastrar aluno)


               if ws-voltar = spaces then
                   call "processamento" using  ws-cadastro,   *> Chamar o programa para cadastrar o aluno
                                               ws-msg-erro,
                                               ws-funcao,
                                               ws-msg

                   if ws-funcao = "ef" then       *> Caso o programa volte com erro fatal
                       perform finaliza-anormal   *> Desvia para o fim anormal
                   end-if
               end-if

           end-perform

           .
       cadastro-aluno-exit.
           exit.

      *>---------------------------------------------------------------
      *>   Cadastrar Notas
      *>---------------------------------------------------------------
       cadastro-notas section.

           perform until ws-voltar = "X"
                      or ws-voltar = "x"

               move zero   to  ws-nota(01)         *> Inicializa as variáveis de tela
               move zero   to  ws-nota(02)
               move zero   to  ws-nota(03)
               move zero   to  ws-nota(04)
               move zero   to  ws-cod_aluno
               move spaces to  ws-nome_aluno

               display sc-tela-cad-notas
               accept  sc-tela-cad-notas

               if ws-voltar = spaces then
                   move "cc"   to  ws-funcao       *> Movendo a função a ser utilizada no programa de processamento (Consultar cadastro)

                   call "processamento" using  ws-cadastro,  *>  Chamar programa para consultar o aluno
                                               ws-msg-erro,  *>  referente ao código solicitado
                                               ws-funcao,
                                               ws-msg

                   if ws-funcao = "ef" then        *> Caso o programa volte com erro fatal
                       perform finaliza-anormal    *> Desvia para o fim anormal
                   end-if

                   display sc-tela-cad-notas
                   accept  sc-tela-cad-notas

                   move "cn"   to  ws-funcao

                   call "processamento" using  ws-cadastro,  *>  Chamar programa para cadastrar as notas
                                               ws-msg-erro,  *>  no arquivo
                                               ws-funcao,
                                               ws-msg

                   if ws-funcao = "ef" then        *> Caso o programa volte com erro fatal
                       perform finaliza-anormal    *> Desvia para o fim anormal
                   end-if
               end-if

           end-perform
           .
       cadastro-notas-exit.
           exit.

      *>-----------------------------------------------------------------------
      *>   Consultar Cadastro - Consulta Indexada
      *>-----------------------------------------------------------------------
       consulta-cadastro section.

           perform until ws-voltar = "X"
                      or ws-voltar = "x"

               move "cc"   to  ws-funcao       *> Movendo a função a ser utilizada no programa de processamento (Consulta cadastro)

               move zero   to  ws-cod_aluno    *> Inicializa as variáveis da tela
               move spaces to  ws-nome_aluno
               move zero   to  ws-dia
               move zero   to  ws-mes
               move zero   to  ws-ano
               move spaces to  ws-nome_mae
               move spaces to  ws-nome_pai
               move spaces to  ws-rua
               move zero   to  ws-n_casa
               move spaces to  ws-bairro
               move spaces to  ws-cidade
               move spaces to  ws-uf
               move spaces to  ws-cep
               move spaces to  ws-fone_pais
               move zero   to  ws-nota(01)
               move zero   to  ws-nota(02)
               move zero   to  ws-nota(03)
               move zero   to  ws-nota(04)
               move zero   to  ws-media
               move spaces to  ws-situacao


               display sc-tela-consulta-cad
               accept  sc-tela-consulta-cad

               move spaces to ws-msg

               if  ws-voltar = spaces then

                   call "processamento" using  ws-cadastro,  *> Chama o programa para cadastrar aluno
                                               ws-msg-erro,
                                               ws-funcao,
                                               ws-msg

                   if ws-funcao = "ef" then        *> Caso o programa volte com um erro fatal
                       perform finaliza-anormal    *> Desvia para o fim anormal
                   end-if
                   if ws-msg = spaces then
                       display sc-tela-consulta-cad
                       accept  sc-tela-consulta-cad
                   end-if

               end-if


           end-perform

           .
       consulta-cadastro-exit.
           exit.

       *>----------------------------------------------------------------------
       *>  Listar Cadastros - Consulta Sequencial
       *>----------------------------------------------------------------------
       lista-cadastro section.

           move spaces to  ws-next-prev            *> Inicializa as variáveis de tela
           move zero   to  ws-cod_aluno
           move spaces to  ws-nome_aluno
           move zero   to  ws-dia
           move zero   to  ws-mes
           move zero   to  ws-ano
           move spaces to  ws-nome_mae
           move spaces to  ws-nome_pai
           move spaces to  ws-rua
           move zero   to  ws-n_casa
           move spaces to  ws-bairro
           move spaces to  ws-cidade
           move spaces to  ws-uf
           move spaces to  ws-cep
           move spaces to  ws-fone_pais
           move zero   to  ws-nota(01)
           move zero   to  ws-nota(02)
           move zero   to  ws-nota(03)
           move zero   to  ws-nota(04)
           move zero   to  ws-media
           move spaces to  ws-situacao

           perform until ws-voltar = "X"
                      or ws-voltar = "x"
               if ws-voltar = spaces then
                   move "lc"   to  ws-funcao       *> Movendo a função a ser utilizada no programa de processamento (Listar cadastro)
                   move spaces to  ws-edita-cadastro
                   move spaces to  ws-deleta-cadastro
                   move spaces to  ws-ant-cadastro
                   move spaces to  ws-prox-cadastro

                   call "processamento" using  ws-cadastro,   *> Chama o programa para apresentar o cadastro na tela
                                               ws-msg-erro,
                                               ws-funcao,
                                               ws-msg,
                                               ws-next-prev
                   if ws-funcao = "ef" then        *> Caso o programa volte com erro fatal
                       perform finaliza-anormal    *> Desvia para o fim anormal
                   end-if

                   display sc-tela-listar-cad
                   accept  sc-tela-listar-cad

                   if ws-edita-cadastro = "X"
                   or ws-edita-cadastro = "x" then

                       move "al" to ws-next-prev   *> Movendo a função a ser utilizada no programa de processamento (Alterar cadastro)
                       move "Confirme a Alteracao!" to ws-msg
                       perform alterar-cadastro
                       move spaces to ws-msg

                   end-if

                   if ws-deleta-cadastro = "X"
                   or ws-deleta-cadastro = "x" then

                       move "dl" to ws-next-prev   *> Movendo a função a ser utilizada no programa de processamento (Deletar cadastro)
                       move "Confirme a Exculsao do Registro!" to ws-msg
                       perform deletar-cadastro
                       move spaces to ws-msg
                       move "x" to ws-prox-cadastro

                   end-if

                   if ws-ant-cadastro = "X"
                   or ws-ant-cadastro = "x" then
                       move "lp" to ws-next-prev   *> Movendo a função a ser utilizada no programa de processamento (Consultar anterior)
                   end-if

                   if ws-prox-cadastro = "X"
                   or ws-prox-cadastro = "x" then
                       move "ln" to ws-next-prev   *> Movendo a função a ser utilizada no programa de processamento (Consultar próximo)
                   end-if


                   move spaces to ws-msg
               end-if
           end-perform

           .
       lista-cadastro-exit.
           exit.

       alterar-cadastro section.

           perform until ws-voltar = "X"
                      or ws-voltar = "x"
               move spaces to ws-confirmar

               display sc-tela-alterar-cad
               accept  sc-tela-alterar-cad

               if ws-confirmar = "X"
               or ws-confirmar = "x" then
                   call "processamento" using  ws-cadastro,   *> Chamar programa para alterar o cadastro
                                               ws-msg-erro,
                                               ws-funcao,
                                               ws-msg,
                                               ws-next-prev
                   if ws-funcao = "ef" then        *> Caso o programa volte com erro fatal
                       perform finaliza-anormal    *> Desvia para o fim anormal
                   end-if

               end-if
           end-perform


           .
       alterar-cadastro-exit.
           exit.

       deletar-cadastro section.

           perform until ws-voltar = "X"
                      or ws-voltar = "x"
               move spaces to ws-confirmar

               display sc-tela-alterar-cad
               accept  sc-tela-alterar-cad

               if ws-confirmar = "X"
               or ws-confirmar = "x"
                   call "processamento" using  ws-cadastro, *> Chama o programa para deletar cadastro
                                               ws-msg-erro,
                                               ws-funcao,
                                               ws-msg,
                                               ws-next-prev
                   if ws-funcao = "ef" then        *> Caso o programa volte com erro fatal
                       perform finaliza-anormal    *> Desvia para o fim anormal
                   end-if
               end-if
           end-perform


           .
       deletar-cadastro-exit.
           exit.

      *>------------------------------------------------------------------------
      *>  Finalização  Anormal
      *>------------------------------------------------------------------------
       finaliza-anormal section.
           display erase
           display ws-msg-erro                     *> Exibe o erro que fez o programa ser abortado
           Stop run
           .
       finaliza-anormal-exit.
           exit.


       finaliza section.

           display erase
           display "--- Operacao Encerrada ---"
           Stop Run.

           .
       finaliza-exit.
           exit.













