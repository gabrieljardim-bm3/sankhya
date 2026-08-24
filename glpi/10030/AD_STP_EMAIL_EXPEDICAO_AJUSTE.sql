CREATE OR REPLACE PROCEDURE GRUPOSOULPRD.AD_STP_EMAIL_EXPEDICAO_AJUSTE (
    P_NUNOTA      INT, 
    P_EMAIL_DEST  VARCHAR2
) AS 
    V_MENSAGEM_EMAIL CLOB;
    V_NUMNOTA        INT;
    V_RAZAOSOCIAL    VARCHAR2(200);
BEGIN
    -- Busca os dados básicos da nota gerada
    SELECT CAB.NUMNOTA, PAR.RAZAOSOCIAL
    INTO V_NUMNOTA, V_RAZAOSOCIAL
    FROM TGFCAB CAB
    LEFT JOIN TGFPAR PAR ON CAB.CODPARC = PAR.CODPARC
    WHERE CAB.NUNOTA = P_NUNOTA;

    -- Corpo do e-mail focado na Expedição
    V_MENSAGEM_EMAIL := '<table width="600" border="0" align="center" cellpadding="0" cellspacing="0" style="font-family: Arial, sans-serif;">' ||
                        '<tr><td style="background:#2C3E50; color:#fff; padding:15px;"><h2>Aviso de Expedição: Nota de Ajuste Gerada</h2></td></tr>' ||
                        '<tr><td style="padding:20px; color:#333;">' ||
                        '<p>Olá equipe de Expedição,</p>' ||
                        '<p>Informamos que uma <b>Nota de Ajuste</b> acaba de ser gerada automaticamente a partir do processo de conferência de entrada:</p>' ||
                        '<ul>' ||
                        '  <li><b>Nro. Único:</b> ' || P_NUNOTA || '</li>' ||
                        '  <li><b>Nota Fiscal:</b> ' || V_NUMNOTA || '</li>' ||
                        '  <li><b>Fornecedor:</b> ' || V_RAZAOSOCIAL || '</li>' ||
                        '</ul>' ||
                        '<p>Este é apenas um e-mail informativo para acompanhamento interno do recebimento físico.</p>' ||
                        '<p>Atenciosamente,<br><b>Sankhya ERP</b></p>' ||
                        '</td></tr>' ||
                        '</table>';

    -- Insere na fila de envio do Sankhya
    GRUPOSOULPRD.Insere_Msg_Fila_Bimovel_Email(
        P_ASSUNTO      => 'Expedição: Gerada Nota de Ajuste Nro. ' || V_NUMNOTA,
        P_CODCON       => 0,
        P_MENSAGEM     => V_MENSAGEM_EMAIL,
        P_TIPOENVIO    => 'E',
        P_MAXTENTENVIO => 3,
        P_EMAIL        => P_EMAIL_DEST
    );
END;
/