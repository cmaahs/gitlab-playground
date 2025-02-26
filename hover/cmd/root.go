package cmd

import (
	"fmt"
	"os"
	"strings"

	"update-hover-dns/config"

	"github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	// "gopkg.in/yaml.v3"
	// "sigs.k8s.io/yaml"
)

type (
	Project struct {
		ID     int    `json:"id"`
		Name   string `json:"name"`
		Path   string `json:"path"`
		SSHURL string `json:"ssh_url_to_repo"`
	}
)

var (
	cfgFile   string
	semVer    string
	gitCommit string
	gitRef    string
	buildDate string

	c = &config.Config{}
)

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "update-hover-dns",
	Short: "",
	Long: `EXAMPLE:

  TODO: add description

  > update-hover-dns

`,
	PersistentPreRun: func(cmd *cobra.Command, args []string) {
		c.VersionDetail.SemVer = semVer
		c.VersionDetail.BuildDate = buildDate
		c.VersionDetail.GitCommit = gitCommit
		c.VersionDetail.GitRef = gitRef
		c.VersionJSON = fmt.Sprintf("{\"SemVer\": \"%s\", \"BuildDate\": \"%s\", \"GitCommit\": \"%s\", \"GitRef\": \"%s\"}", semVer, buildDate, gitCommit, gitRef)
		if c.OutputFormat != "" {
			c.FormatOverridden = true
			c.NoHeaders = false
			c.OutputFormat = strings.ToLower(c.OutputFormat)
			switch c.OutputFormat {
			case "json", "gron", "yaml", "text", "table", "raw":
				break
			default:
				fmt.Println("Valid options for -o are [json|gron|text|table|yaml|raw]")
				os.Exit(1)
			}
		}

		if os.Args[1] != "version" { // && os.Args[1] != "config" {
		}
	},
	Run: func(cmd *cobra.Command, args []string) {

		// project, _ := cmd.Flags().GetString("project")
		// if len(project) == 0 {
		// 	project = "ayx-platform/services/connectors"
		// }
	},
}

func istable(v interface{}) bool {
	_, ok := v.(map[string]interface{})
	return ok
}

func isarray(v interface{}) bool {
	_, ok := v.([]interface{})
	return ok
}

// func splitTemplate(templateString string) []string {
// 	var splitString []string
// 	newString := ""
// 	scanner := bufio.NewScanner(strings.NewReader(templateString))
// 	for scanner.Scan() {
// 		if scanner.Text() == "---" {
// 			splitString = append(splitString, newString)
// 			newString = ""
// 		} else {
// 			newString += fmt.Sprintf("%s\n", scanner.Text())
// 		}
// 	}
// 	if len(newString) > 0 {
// 		splitString = append(splitString, newString)
// 	}
// 	if err := scanner.Err(); err != nil {
// 		fmt.Println("Error converting to Template Array")
// 	}

// 	return splitString
// }

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute() {
	cobra.CheckErr(rootCmd.Execute())
}

func init() {
	cobra.OnInitialize(initConfig)

	rootCmd.PersistentFlags().StringVar(&cfgFile, "config", "", "config file (default is $HOME/.update-hover-dns.yaml)")
	rootCmd.PersistentFlags().StringVarP(&c.OutputFormat, "output", "o", "", "Set an output format: json, text, yaml, gron, md")

}

// initConfig reads in config file and ENV variables if set.
func initConfig() {
	if cfgFile != "" {
		// Use config file from the flag.
		viper.SetConfigFile(cfgFile)
	} else {
		// Find home directory.
		home, err := os.UserHomeDir()
		cobra.CheckErr(err)

		workDir := fmt.Sprintf("%s/.config/update-hover-dns", home)
		if _, err := os.Stat(workDir); err != nil {
			if os.IsNotExist(err) {
				mkerr := os.MkdirAll(workDir, os.ModePerm)
				if mkerr != nil {
					logrus.Fatal("Error creating ~/.config/update-hover-dns directory", mkerr)
				}
			}
		}
		if stat, err := os.Stat(workDir); err == nil && stat.IsDir() {
			configFile := fmt.Sprintf("%s/%s", workDir, "config.yaml")
			createRestrictedConfigFile(configFile)
			viper.SetConfigFile(configFile)
		} else {
			logrus.Info("The ~/.config/update-hover-dns path is a file and not a directory, please remove the 'update-hover-dns' file.")
			os.Exit(1)
		}
	}

	viper.AutomaticEnv() // read in environment variables that match

	// If a config file is found, read it in.
	if err := viper.ReadInConfig(); err != nil {
		logrus.Warn("Failed to read viper config file.")
	}
}

func createRestrictedConfigFile(fileName string) {
	if _, err := os.Stat(fileName); err != nil {
		if os.IsNotExist(err) {
			file, ferr := os.Create(fileName)
			if ferr != nil {
				logrus.Info("Unable to create the configfile.")
				os.Exit(1)
			}
			mode := int(0600)
			if cherr := file.Chmod(os.FileMode(mode)); cherr != nil {
				logrus.Info("Chmod for config file failed, please set the mode to 0600.")
			}
		}
	}
}
