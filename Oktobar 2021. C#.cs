using System;
using System.Data;
using Oracle.ManagedDataAccess.Client; // Proveri da koristiš odgovarajući Oracle provider

namespace Zadatak
{
    class Program
    {
        static void Main(string[] args)
        {
            // 1. Konekcioni string
            string conString = "Data Source=160.99.9.63/gislab.ni.ac.rs;User Id=S18856;Password=S18856;";
            OracleConnection con = null;

            try
            {
                // 2. Otvaranje konekcije
                con = new OracleConnection(conString);
                con.Open();

                // 3. Unos ID kluba
                Console.WriteLine("Unesite ID Kluba:");
                int idKluba = int.Parse(Console.ReadLine());

                // 4. SQL upit
                string strSQL = @"SELECT SPORTISTA.IME, SPORTISTA.PREZIME, SPORTISTA.GRAD 
                                  FROM SPORTISTA 
                                  INNER JOIN CLAN ON SPORTISTA.ID = CLAN.ID_SPORTISTE 
                                  INNER JOIN KLUB ON CLAN.ID_KLUBA = KLUB.ID 
                                  WHERE CLAN.TIM = 'PRVI' 
                                  AND CLAN.ID_SPORTISTE IN (
                                      SELECT DISTINCT C2.ID_SPORTISTE 
                                      FROM CLAN C2 
                                      INNER JOIN KLUB K2 ON C2.ID_KLUBA = K2.ID 
                                      WHERE K2.LOKACIJA = 'NIS' AND C2.TIM = 'SKOLA'
                                  ) 
                                  AND KLUB.ID = :idKluba";

                // 5. Pravimo DataAdapter i dodajemo parametre
                OracleDataAdapter da = new OracleDataAdapter(strSQL, con);
                da.SelectCommand.Parameters.Add(new OracleParameter(":idKluba", idKluba));

                // 6. Kreiramo DataSet za rezultate
                DataSet ds = new DataSet();
                da.Fill(ds, "Rezultati");

                // 7. Ispisujemo rezultate
                foreach (DataRow row in ds.Tables["Rezultati"].Rows)
                {
                    Console.WriteLine($"Ime: {row["IME"]}, Prezime: {row["PREZIME"]}, Grad: {row["GRAD"]}");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Greška: {ex.Message}");
            }
            finally
            {
                // 8. Zatvaranje konekcije
                if (con != null && con.State == ConnectionState.Open)
                {
                    con.Close();
                }
            }
        }
    }
}
