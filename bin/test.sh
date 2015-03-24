CommandLineOptions__config_file=""
CommandLineOptions__debug_level=""

getopt_results=`getopt -s bash -o c:d:: --long config_file:,debug_level:: -- "$@"`

if test $? != 0
then
    echo "unrecognized option"
    exit 1
fi

eval set -- "$getopt_results"

while true
do
    case "$1" in
        --config_file)
            CommandLineOptions__config_file="$2";
            shift 2;
            ;;
        --debug_level)
            CommandLineOptions__debug_level="$2";
            shift 2;
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "$0: unparseable option $1"
            EXCEPTION=$Main__ParameterException
            EXCEPTION_MSG="unparseable option $1"
            exit 1
            ;;
    esac
done

if test "x$CommandLineOptions__config_file" == "x"
then
    echo "$0: missing config_file parameter"
    EXCEPTION=$Main__ParameterException
    EXCEPTION_MSG="missing config_file parameter"
    exit 1
fi
