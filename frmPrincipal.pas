unit frmPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Edit, FMX.Controls.Presentation, FMX.Layouts;

type
  TfPrincipal = class(TForm)
    Rectangle2: TRectangle;
    Rectangle1: TRectangle;
    Rectangle4: TRectangle;
    edCaminho: TEdit;
    EditButton1: TEditButton;
    sbExecute: TSpeedButton;
    Layout1: TLayout;
    Text1: TText;
    Layout2: TLayout;
    rbCompactar: TRadioButton;
    rbExtrair: TRadioButton;
    odAbrir: TOpenDialog;
    procedure rbExtrairClick(Sender: TObject);
    procedure rbCompactarClick(Sender: TObject);
    procedure EditButton1Click(Sender: TObject);
    procedure sbExecuteClick(Sender: TObject);
  private
    { Private declarations }
    procedure Compactar(arquivo, caminhoparagravar : String);
    procedure Extrair(arquivo, caminhoparaextrair : String);
    procedure LimparEditCaminho;
    procedure AbrirDiretorioDoProcesso(caminhoArquivosProcessados : String);
    function Validar : Boolean;
  public
    { Public declarations }
  end;

var
  fPrincipal: TfPrincipal;

implementation

uses
  System.Zip, System.StrUtils, System.IOUtils, ShellAPI, Windows;

{$R *.fmx}

procedure TfPrincipal.AbrirDiretorioDoProcesso(
  caminhoArquivosProcessados: String);
begin
  ShellExecute(0, PChar('open'), PChar(caminhoArquivosProcessados), nil, nil, SW_NORMAL);
end;

procedure TfPrincipal.Compactar(arquivo, caminhoparagravar : String);
begin
  var Zip := TZipFile.Create;
  try
    Zip.Open(TPath.Combine(caminhoparagravar, ExtractFileName(arquivo) + '.zip'), TZipMode.zmWrite);
    Zip.Add(arquivo);
    Zip.Close;
  finally
    Zip.Free;
  end;
end;

procedure TfPrincipal.EditButton1Click(Sender: TObject);
begin
  if rbExtrair.IsChecked then
    odAbrir.Title := 'Selecione o arquivo para extrair';


  if rbCompactar.IsChecked then
    odAbrir.Title := 'Selecione o arquivo para compactar';


  if odAbrir.Execute then
      edCaminho.Text := odAbrir.FileName;
end;

procedure TfPrincipal.Extrair(arquivo, caminhoparaextrair : String);
begin
  var Zip := TZipFile.Create;
  try
    Zip.Open(arquivo, TZipMode.zmRead);
    Zip.ExtractAll(caminhoparaextrair);
    Zip.Close;
  finally
    Zip.Free;
  end;
end;

procedure TfPrincipal.LimparEditCaminho;
begin
  edCaminho.Text := '';
end;

procedure TfPrincipal.rbCompactarClick(Sender: TObject);
begin
  rbCompactar.IsChecked := not rbExtrair.IsChecked;
  LimparEditCaminho;
end;

procedure TfPrincipal.rbExtrairClick(Sender: TObject);
begin
  rbExtrair.IsChecked := not rbCompactar.IsChecked;
  LimparEditCaminho;
end;

procedure TfPrincipal.sbExecuteClick(Sender: TObject);
begin
  if Validar then
  begin
    var lDirProcessado : String;

    if SelectDirectory( 'Selecione o diretório para ' +
      ifThen(rbCompactar.IsChecked, 'salvar o zip.', 'extrair o zip'), GetCurrentDir, lDirProcessado) then
    begin
      if rbCompactar.IsChecked then
        Compactar(edCaminho.Text, lDirProcessado);

      if rbExtrair.IsChecked then
        Extrair(edCaminho.Text, lDirProcessado);

      LimparEditCaminho;
      ShowMessage('Processo Concluído.');
      AbrirDiretorioDoProcesso(lDirProcessado);
    end;
  end;
end;

function TfPrincipal.Validar: Boolean;
begin
  Result := not edCaminho.Text.IsEmpty;
end;

end.
