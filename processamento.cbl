      $ set sourceformat"free"

      *>Divisão de identificação do programa
       Identification Division.
       Program-id. "processamento".
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

           select arqCadAl assign to "arqCadAlIndex.dat"
           organization is indexed
           access mode is dynamic
           lock mode is automatic
           record key is fd-cod_aluno
           file status is ws-fs-arqCadAl.


       I-O-Control.


      *>Declaração de variáveis
       Data Division.

      *>----Variaveis de arquivos
       File Section.

       fd arqCadAl.

       01  fd-cadastro.
           05  fd-cod_aluno                        pic 9(05).
           05  fd-nome_aluno                       pic x(35).
           05  fd-data_nasc.
               10  fd-dia                          pic 9(02).
               10  fd-mes                          pic 9(02).
               10  fd-ano                          pic 9(04).
           05  fd-endereco.
               10  fd-cep                          pic x(09).
               10  fd-rua                          pic x(25).
               10  fd-n_casa                       pic 9(05).
               10  fd-bairro                       pic x(20).
               10  fd-cidade                       pic x(20).
               10  fd-uf                           pic x(02).
           05  fd-nome_mae                         pic x(35).
           05  fd-nome_pai                         pic x(35).
           05  fd-fone_pais                        pic x(15).
           05  fd-notas-todas.
               10  fd-notas occurs 4.
                   15 fd-nota                      pic 99,99.
           05  fd-media                            pic 99,99.
           05  fd-situacao                         pic x(09).

      *>----Variaveis de trabalho
       Working-storage Section.

       77  ws-fs-arqCadAl                          pic x(02).

       77  ws-ind                                  pic 9(01).

       01  ws-notas-todas.
           05  ws-notas_aux occurs 4.
               10  ws-nota_aux                     pic 99,99.
       01  ws-notas-todas-frmt.
           05  ws-notas_aux_frmt occurs 4.
               10  ws-nota_aux_frmt                pic 9(02)v99.
       01 ws-media                                 pic 99,99.
       01 ws-media-frmt                            pic 9(02)v99.

      *>----Variaveis para comunicação entre programas
       Linkage Section.

       01 lk-msg-erro.
          05 lk-msg-erro-ofsset                    pic 9(04).
          05 filler                                pic x(01) value "-".
          05 lk-msg-erro-cod                       pic 9(02).
          05 filler                                pic x(01) value space.
          05 lk-msg-erro-text                      pic x(42).


       01  lk-cadastro.
           05  lk-cod_aluno                        pic 9(05).
           05  lk-nome_aluno                       pic x(35).
           05  lk-data_nasc.
               10  lk-dia                          pic 9(02).
               10  lk-mes                          pic 9(02).
               10  lk-ano                          pic 9(04).
           05  lk-endereco.
               10  lk-cep                          pic x(09).
               10  lk-rua                          pic x(25).
               10  lk-n_casa                       pic 9(05).
               10  lk-bairro                       pic x(20).
               10  lk-cidade                       pic x(20).
               10  lk-uf                           pic x(02).
           05  lk-nome_mae                         pic x(35).
           05  lk-nome_pai                         pic x(35).
           05  lk-fone_pais                        pic x(15).
           05  lk-notas-todas.
               10  lk-notas occurs 4.
                   15 lk-nota                      pic 99,99.
           05  lk-media                            pic 99,99.
           05  lk-situacao                         pic x(09).

       77  lk-funcao                               pic x(02).
       77  lk-msg                                  pic x(50).
       77  lk-next-prev                            pic x(02).



      *>----Declaração de tela
       Screen Section.


      *>Declaração do corpo do programa
       Procedure Division using lk-cadastro,
                                lk-msg-erro,
                                lk-funcao,
                                lk-msg,
                                lk-next-prev.

           perform inicializa.
           perform procedimento.
           perform finaliza.

       inicializa section.

           open i-o arqCadAl   *> open i-o abre o arquivo para leitura e escrita
           if ws-fs-arqCadAl  <> "00"
           and ws-fs-arqCadAl <> "05" then
               move 1                                to lk-msg-erro-ofsset
               move ws-fs-arqCadAl                   to lk-msg-erro-cod
               move "Erro ao abrir arq. arqTemp "    to lk-msg-erro-text
               perform finaliza-anormal
           end-if
           .
       inicializa-exit.
           exit.

      *>------------------------------------------------------------------------
      *>   Procedimento principal
      *>------------------------------------------------------------------------
       procedimento section.

           evaluate lk-funcao                      *> Identificar funcao passada pelo programa raiz
               when = "bc"
                   perform buscar-cod-aluno
               when = "ca"
                   perform cadastrar-aluno
               when = "cn"
                   perform cadastrar-nota
               when = "cc"
                   perform consultar-cadastro
               when = "lc"
                   perform listar-cadastro
           end-evaluate

           .
       procedimento-exit.
           exit.

      *>------------------------------------------------------------------------
      *>   Cadastro de aluno - Escreve no arquivo
      *>------------------------------------------------------------------------
       cadastrar-aluno section.


      *> -------------  Salvar dados no arquivo

           write fd-cadastro from lk-cadastro
           if ws-fs-arqCadAl <> "00" then          *> Erro fatal
               move 1                                   to lk-msg-erro-ofsset
               move ws-fs-arqCadAl                      to lk-msg-erro-cod
               move "Erro ao Escrever arq. arqCadAl!"   to lk-msg-erro-text
               perform finaliza-anormal            *> Desvio para fim anormal
           end-if

      *> -------------

           .
       cadastrar-aluno-exit.
           exit.

      *>------------------------------------------------------------------------
      *>   Buscar próximo código disponível para cadastro
      *>------------------------------------------------------------------------
       buscar-cod-aluno section.

           move 1 to fd-cod_aluno
           start arqCadAl                          *> Dar start no arquivo
           if ws-fs-arqCadAl = "00" then
               perform until ws-fs-arqCadAL = "10"   *> Rodar até encontrar o último registro
                   read arqCadAl next
                   move fd-cod_aluno to lk-cod_aluno   *> Mover dados do arquivo para as variaveis do programa
               end-perform
               add 1                 to lk-cod_aluno   *> Adicionar 1 ao código
           else
               if ws-fs-arqCadAl = "23" then       *> Caso ainda não tenha nenhum registro no arquivo
                   move 1 to lk-cod_aluno
               else                                *> Erro fatal
                   move 2                                   to lk-msg-erro-ofsset
                   move ws-fs-arqCadAl                      to lk-msg-erro-cod
                   move "Erro Ao Encontrar Prox. Cod."      to lk-msg-erro-text
                   perform finaliza-anormal        *> Desvio para o fim anormal
               end-if
           end-if

           .
       buscar-cod-aluno-exit.
           exit.

      *>-----------------------------------------------------------------------
      *>   Cadastro de nota - editar no arquivo
      *>-----------------------------------------------------------------------
       cadastrar-nota section.

           move lk-cod_aluno      to  fd-cod_aluno   *> Mover variavel do programa para variavel de arquivo
           read arqCadAl                             *> Ler arquivo
           if  ws-fs-arqCadAl <> "00" then           *> Erro fatal
               move 3                                   to lk-msg-erro-ofsset
               move ws-fs-arqCadAl                      to lk-msg-erro-cod
               move "Erro ao Ler Arquivo"               to lk-msg-erro-text
               perform finaliza-anormal           *> Desvio para fim anormal
           else
               perform calcula-media              *> Desvio para calcular média do aluno

       *>------------- Sobrescrever dados no arquivo
               move lk-media          to  fd-media
               move lk-situacao       to  fd-situacao
               move lk-notas-todas    to  fd-notas-todas
               rewrite fd-cadastro
       *>-------------

               if ws-fs-arqCadAl  <> 00 then      *> Erro fatal
                   move 4                                       to lk-msg-erro-ofsset
                   move ws-fs-arqCadAl                          to lk-msg-erro-cod
                   move "Erro ao Gravar Notas arq. arqCadAl!"   to lk-msg-erro-text
                   perform finaliza-anormal       *> Desvio para o fim anormal
               end-if
           end-if


           .
       cadastrar-nota-exit.
           exit.

       *>----------------------------------------------------------------------
       *>  Calcular média
       *>----------------------------------------------------------------------
       calcula-media section.

           move zero           to ws-media-frmt         *> Movendo as váriaveis para auxilires
           move lk-notas-todas to ws-notas-todas        *> que possuem o layout correto
           move ws-nota_aux(1) to ws-nota_aux_frmt(1)   *> para realizar calculos
           move ws-nota_aux(2) to ws-nota_aux_frmt(2)
           move ws-nota_aux(3) to ws-nota_aux_frmt(3)
           move ws-nota_aux(4) to ws-nota_aux_frmt(4)

           compute ws-media-frmt = (ws-nota_aux_frmt(1) +   *> Calcular média
                                    ws-nota_aux_frmt(2) +
                                    ws-nota_aux_frmt(3) +
                                    ws-nota_aux_frmt(4)) /4

           move ws-media-frmt to ws-media          *> Mover resultado da média para váriavel no
           move ws-media      to lk-media          *> layout correto para apresentar na tela

           if ws-media-frmt >= 7 then
               move "Aprovado"  to lk-situacao     *> Caso atinja a média
           else
               move "Reprovado" to lk-situacao     *> Caso não atinja a média
           end-if

           .
       calcula-media-exit.
           exit.

      *>------------------------------------------------------------------------
      *>  Consulta de cadastro  - lê o arquivo de forma indexada
      *>------------------------------------------------------------------------
       consultar-cadastro section.


      *> -------------  Ler dados indexados do arquivo

           move lk-cod_aluno to fd-cod_aluno       *> Mover código solicitado para leitura
           read arqCadAl                           *> Ler arquivo
           if  ws-fs-arqCadAl = "00" then
               move  fd-cadastro       to  lk-cadastro   *> Caso o código seja localizado, mover dados para as váriaveis do programa
           else
               if ws-fs-arqCadAl = "23" then       *> Caso o código informado não esteja registrado
                   move "Codigo Informado Nao Registrado." to lk-msg
               else                                *> Erro falat
                   move 5                                   to lk-msg-erro-ofsset
                   move ws-fs-arqCadAl                      to lk-msg-erro-cod
                   move "Erro ao Ler arq. arqCadAl "        to lk-msg-erro-text
                   perform finaliza-anormal        *> Desvio para fim anormal
               end-if
           end-if

      *> -------------

           .
       consultar-cadastro-exit.
           exit.

       *>------------------------------------------
       *>  Listar Cadstros - Consulta Sequencial
       *>------------------------------------------
       listar-cadastro section.

           evaluate lk-next-prev                   *> Identificar função da tela de listar cadastros
               when = spaces or "ln"               *> solicitada
                   perform consulta-next
               when = "lp"
                   perform consulta-prev
               when = "al"
                   perform alterar-cadastro
               when = "dl"
                   perform deletar-cadastro
           end-evaluate

           .
       listar-cadastro-exit.
           exit.

       consulta-next section.

           if lk-next-prev = "ln" then             *> Caso tenha sido solicitado o próximo cadastro
               read arqCadAl next                  *> Ler arquivo
               if ws-fs-arqCadAl <> "00" then
                   if ws-fs-arqCadAl = "10" then   *> Caso encontre o último registro
                       move "Ultimo Registro!" to lk-msg
                       move fd-cadastro to lk-cadastro
                   else                            *> Erro fatal
                       move 6                                  to lk-msg-erro-ofsset
                       move ws-fs-arqCadAl                     to lk-msg-erro-cod
                       move "Erro ao Ler Arq. arqCadAl!"       to lk-msg-erro-text
                       perform finaliza-anormal    *> Desvio para o fim anormal
                   end-if
               else
                   move fd-cadastro to lk-cadastro   *> Mover dados do arquivo para variaveis do programa
               end-if
           else
               move 1 to fd-cod_aluno                *> Caso não tenha nenhum registro na memória ainda
               start arqCadAl
               if ws-fs-arqCadAl <> "00"             *>Erro fatal
                   move 7                                  to lk-msg-erro-ofsset
                   move ws-fs-arqCadAl                     to lk-msg-erro-cod
                   move "Erro ao Ler Arq. arqCadAl!"       to lk-msg-erro-text
                   perform finaliza-anormal          *> Desvio para o fim anormal
               else
                   move fd-cadastro to lk-cadastro
           end-if

           .
       consulta-next-exit.
           exit.

       consulta-prev section.

           read arqCadAl previous                  *> Caso tenha sido solicitado o cadastro anterior
           if ws-fs-arqCadAl <> "00" then
               if ws-fs-arqCadAL = "10" then       *> Caso encontre o último registro
                   move "Ultimo Registro!" to lk-msg
                   move fd-cadastro to lk-cadastro
               else                                *> Erro fatal
                   move 8                                  to lk-msg-erro-ofsset
                   move ws-fs-arqCadAl                     to lk-msg-erro-cod
                   move "Erro ao Ler Arq. arqCadAl! "      to lk-msg-erro-text
                   perform finaliza-anormal        *> Desvio para o fim anormal
               end-if
           else
               move fd-cadastro to lk-cadastro     *> Mover os dados do arquivo para as variáveis do programa
           end-if

           .
       consulta-prev-exit.
           exit.

       alterar-cadastro section.

           move lk-cod_aluno      to  fd-cod_aluno   *> Mover o código solicitado para alterar
           read arqCadAl                             *> Ler arquivo
           if  ws-fs-arqCadAl <> "00" then           *> Erro fatal
               move 9                                   to lk-msg-erro-ofsset
               move ws-fs-arqCadAl                      to lk-msg-erro-cod
               move "Erro ao Ler Arquivo"               to lk-msg-erro-text
               perform finaliza-anormal              *> Desvio para o fim anormal
           else
               perform calcula-media               *> Desvia para o calculo da média para caso alguma nota tenha sido alterada

       *>------------- Sobrescrever dados no arquivo
               move lk-cadastro to fd-cadastro
               rewrite fd-cadastro
       *>-------------

               if ws-fs-arqCadAl  <> 00 then       *> Erro fatal
                   move 10                                       to lk-msg-erro-ofsset
                   move ws-fs-arqCadAl                           to lk-msg-erro-cod
                   move "Erro ao Alterar Cadastro!"              to lk-msg-erro-text
                   perform finaliza-anormal        *> Desvio para o fim anormal
               else
                   move "Cadastro Alterado com Sucesso!" to lk-msg
               end-if
           end-if

           .
       alterar-cadastro-exit.
           exit.

       deletar-cadastro section.

           move lk-cod_aluno   to    fd-cod_aluno   *> Move código solicitado para deletar
           delete arqCadAl                          *> Deleta o arquivo
           if ws-fs-arqCadAl   <> 00 then           *> Erro fatal
               move 11                                 to lk-msg-erro-ofsset
               move ws-fs-arqCadAl                     to lk-msg-erro-cod
               move "Erro ao Deletar Arq. arqCadAl!"   to lk-msg-erro-text
               perform finaliza-anormal             *> Desvio para o fim anormal
           else
               move "Registro Excluido com Sucesso"    to lk-msg
           end-if

           .
       deletar-cadastro-exit.
           exit.


       finaliza-anormal section.

           move "ef" to lk-funcao                  *> Move a funcao de erro fatal para informar ao programa principal
           perform finaliza

           .
       finaliza-anormal-exit.
           exit.

       finaliza section.
                                                   *> Fecha o arquivo
           close arqCadAl
           if ws-fs-arqCadAl <> "00" then          *> Erro fatal ao fechar o arquivo
               move 12                               to lk-msg-erro-ofsset
               move ws-fs-arqCadAl                   to lk-msg-erro-cod
               move "Erro ao Fechar Arq. arqCadAl!"  to lk-msg-erro-text
               move "ef" to lk-funcao              *> Move a funcao de erro fatal para informar ao programa principal
           end-if

      *> ---- Progrmas chamados terminam com "exit programa", já o programa principal
      *> ---- termina com "stop run"
           exit program.

           .
       finaliza-exit.
           exit.













